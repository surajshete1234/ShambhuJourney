import AVFoundation
import UIKit

/// Stitches the journey's photos and video clips into a single exportable movie, with the
/// bundled background music track mixed in. Photos are each rendered into a short silent
/// clip via `ImageToVideoRenderer` so they can be spliced into the same composition as the
/// real video clips.
@Observable
final class VideoExportService {
    enum ExportError: Error {
        case noMedia
        case writerFailed
        case exportFailed
    }

    var progress: Double = 0
    var isExporting = false

    /// 9:16 vertical, the natural shape for a story-style export.
    private let renderSize = CGSize(width: 1080, height: 1920)

    func exportJourney(
        milestones: [JourneyMilestone],
        musicTrackName: String? = AppConstants.storyMusicTrackName,
        secondsPerPhoto: Double = 3.0
    ) async throws -> URL {
        isExporting = true
        progress = 0
        defer { isExporting = false }

        let items = milestones.flatMap { $0.media }
        guard !items.isEmpty else { throw ExportError.noMedia }

        let composition = AVMutableComposition()
        guard let videoTrack = composition.addMutableTrack(
            withMediaType: .video,
            preferredTrackID: kCMPersistentTrackID_Invalid
        ) else {
            throw ExportError.writerFailed
        }

        var cursor = CMTime.zero
        let total = Double(items.count)

        for (index, item) in items.enumerated() {
            if item.type == .video, let url = MediaLibraryService.videoURL(for: item) {
                let asset = AVURLAsset(url: url)
                if let track = try? await asset.loadTracks(withMediaType: .video).first {
                    let duration = try await asset.load(.duration)
                    try videoTrack.insertTimeRange(CMTimeRange(start: .zero, duration: duration), of: track, at: cursor)
                    cursor = cursor + duration
                }
            } else if let image = await MediaCacheService.shared.image(for: item) {
                let duration = CMTime(seconds: secondsPerPhoto, preferredTimescale: 600)
                if let stillURL = try await ImageToVideoRenderer.render(image: image, duration: duration, size: renderSize) {
                    let asset = AVURLAsset(url: stillURL)
                    if let track = try? await asset.loadTracks(withMediaType: .video).first {
                        try videoTrack.insertTimeRange(CMTimeRange(start: .zero, duration: duration), of: track, at: cursor)
                        cursor = cursor + duration
                    }
                }
            }
            progress = Double(index + 1) / total * 0.7
        }

        if let musicTrackName,
           let musicURL = Bundle.main.url(forResource: musicTrackName, withExtension: "mp3"),
           let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) {
            let audioAsset = AVURLAsset(url: musicURL)
            if let sourceAudioTrack = try? await audioAsset.loadTracks(withMediaType: .audio).first {
                let assetDuration = (try? await audioAsset.load(.duration)) ?? cursor
                let audioDuration = min(cursor, assetDuration)
                try? audioTrack.insertTimeRange(CMTimeRange(start: .zero, duration: audioDuration), of: sourceAudioTrack, at: .zero)
            }
        }
        progress = 0.8

        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("ShambhuJourney-\(UUID().uuidString).mov")
        guard let export = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            throw ExportError.exportFailed
        }
        export.outputURL = outputURL
        export.outputFileType = .mov

        await export.export()

        guard export.status == .completed else { throw ExportError.exportFailed }
        progress = 1.0
        return outputURL
    }
}

/// Renders a single `UIImage` into a short silent video clip (aspect-fill, letterbox-free)
/// so still photos can sit alongside real video clips in one `AVMutableComposition`.
enum ImageToVideoRenderer {
    static func render(image: UIImage, duration: CMTime, size: CGSize) async throws -> URL? {
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("still-\(UUID().uuidString).mov")
        let writer = try AVAssetWriter(outputURL: outputURL, fileType: .mov)

        let settings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: size.width,
            AVVideoHeightKey: size.height
        ]
        let input = AVAssetWriterInput(mediaType: .video, outputSettings: settings)
        let attributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
            kCVPixelBufferWidthKey as String: size.width,
            kCVPixelBufferHeightKey as String: size.height
        ]
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input, sourcePixelBufferAttributes: attributes)
        writer.add(input)
        writer.startWriting()
        writer.startSession(atSourceTime: .zero)

        guard let buffer = pixelBuffer(from: image, size: size) else { return nil }
        adaptor.append(buffer, withPresentationTime: .zero)
        let nearEnd = CMTimeSubtract(duration, CMTime(value: 1, timescale: 600))
        adaptor.append(buffer, withPresentationTime: nearEnd)
        input.markAsFinished()
        await writer.finishWriting()
        return outputURL
    }

    private static func pixelBuffer(from image: UIImage, size: CGSize) -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer?
        let attrs: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]
        CVPixelBufferCreate(
            kCFAllocatorDefault, Int(size.width), Int(size.height),
            kCVPixelFormatType_32ARGB, attrs as CFDictionary, &pixelBuffer
        )
        guard let buffer = pixelBuffer else { return nil }

        CVPixelBufferLockBaseAddress(buffer, [])
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }

        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: Int(size.width), height: Int(size.height),
            bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else { return nil }

        // Aspect-fill the source image into the target render size, centered.
        let imageAspect = image.size.width / image.size.height
        let targetAspect = size.width / size.height
        var drawRect = CGRect(origin: .zero, size: size)
        if imageAspect > targetAspect {
            let scaledWidth = size.height * imageAspect
            drawRect = CGRect(x: -(scaledWidth - size.width) / 2, y: 0, width: scaledWidth, height: size.height)
        } else {
            let scaledHeight = size.width / imageAspect
            drawRect = CGRect(x: 0, y: -(scaledHeight - size.height) / 2, width: size.width, height: scaledHeight)
        }

        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        UIGraphicsPushContext(context)
        image.draw(in: CGRect(
            x: drawRect.origin.x,
            y: size.height - drawRect.origin.y - drawRect.height,
            width: drawRect.width,
            height: drawRect.height
        ))
        UIGraphicsPopContext()

        return buffer
    }
}
