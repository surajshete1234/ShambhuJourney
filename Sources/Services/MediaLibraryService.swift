import Foundation
import PhotosUI
import UniformTypeIdentifiers

/// Resolves `MediaItem`s to actual files, whether bundled with the app or imported
/// from the user's device, and handles copying imported media into persistent storage.
enum MediaLibraryService {
    /// Documents/Media — where photos/videos picked from the device are copied so they
    /// survive relaunches (the original PhotosPicker temp file does not persist).
    static var mediaDirectory: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = docs.appendingPathComponent("Media", isDirectory: true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    /// Looks up a bundled resource by base name, trying the "Media" resource folder first
    /// (where real photo/video files should be dropped in) and then the main bundle root.
    static func bundleURL(forMediaNamed name: String) -> URL? {
        let nsName = name as NSString
        let ext = nsName.pathExtension
        let base = ext.isEmpty ? name : nsName.deletingPathExtension
        let candidateExtensions = ext.isEmpty ? ["jpg", "jpeg", "png", "heic", "mov", "mp4"] : [ext]

        for candidate in candidateExtensions {
            if let url = Bundle.main.url(forResource: base, withExtension: candidate, subdirectory: "Media") {
                return url
            }
            if let url = Bundle.main.url(forResource: base, withExtension: candidate) {
                return url
            }
        }
        return nil
    }

    static func videoURL(for item: MediaItem) -> URL? {
        guard item.type == .video else { return nil }
        if let url = item.fileURL { return url }
        if let name = item.assetName { return bundleURL(forMediaNamed: name) }
        return nil
    }

    /// Imports a picked photo/video into Documents/Media and returns a `MediaItem` for it.
    static func importPickerItem(_ item: PhotosPickerItem) async -> MediaItem? {
        guard let data = try? await item.loadTransferable(type: Data.self) else { return nil }
        let isVideo = item.supportedContentTypes.contains { $0.conforms(to: .movie) }
        let ext = isVideo ? "mov" : "jpg"
        let fileName = "\(UUID().uuidString).\(ext)"
        let destination = mediaDirectory.appendingPathComponent(fileName)

        do {
            try data.write(to: destination)
            return MediaItem(type: isVideo ? .video : .photo, fileURL: destination, caption: "", dateTaken: Date())
        } catch {
            return nil
        }
    }
}
