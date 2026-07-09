import SwiftUI
import UIKit

/// Reusable async-loading thumbnail for a `MediaItem`. Shows a soft placeholder while
/// loading and a play badge for video items.
struct MediaThumbnailView: View {
    let item: MediaItem
    @State private var uiImage: UIImage?

    var body: some View {
        ZStack {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .fill(Theme.lavender.opacity(0.3))
                    .overlay(ProgressView())
            }
            if item.type == .video {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.white)
                    .shadow(radius: 4)
            }
        }
        .task(id: item.id) { await loadThumbnail() }
    }

    private func loadThumbnail() async {
        if item.type == .video, let url = MediaLibraryService.videoURL(for: item) {
            uiImage = await VideoThumbnailGenerator.thumbnail(for: url)
        } else {
            uiImage = await MediaCacheService.shared.image(for: item)
        }
    }
}
