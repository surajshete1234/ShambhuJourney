import SwiftUI
import UIKit

/// Full-screen, swipeable photo/video viewer with pinch-to-zoom and double-tap zoom on photos.
struct FullScreenMediaViewer: View {
    let media: [MediaItem]
    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex: Int

    init(media: [MediaItem], startIndex: Int) {
        self.media = media
        self._currentIndex = State(initialValue: startIndex)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TabView(selection: $currentIndex) {
                SwiftUICore.ForEach(media.indexedElements) { pair in
                    MediaZoomableView(item: pair.element)
                        .tag(pair.index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    Spacer()
                    Text("\(currentIndex + 1) / \(media.count)")
                        .font(Theme.Font.caption())
                        .foregroundStyle(.white.opacity(0.7))
                }
                .padding()

                Spacer()

                if !media[currentIndex].caption.isEmpty {
                    Text(media[currentIndex].caption)
                        .font(Theme.Font.body())
                        .foregroundStyle(.white)
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .padding(.bottom, 30)
                }
            }
        }
    }
}

private struct MediaZoomableView: View {
    let item: MediaItem
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    @State private var uiImage: UIImage?

    var body: some View {
        Group {
            if item.type == .video, let url = MediaLibraryService.videoURL(for: item) {
                VideoPlayerView(url: url)
            } else if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in scale = lastScale * value }
                            .onEnded { _ in
                                lastScale = max(1, min(scale, 4))
                                withAnimation(.spring()) { scale = lastScale }
                            }
                    )
                    .onTapGesture(count: 2) {
                        withAnimation(.spring()) {
                            scale = scale > 1 ? 1 : 2
                            lastScale = scale
                        }
                    }
            } else {
                ProgressView().tint(.white)
            }
        }
        .task(id: item.id) {
            if item.type == .photo {
                uiImage = await MediaCacheService.shared.image(for: item)
            }
        }
    }
}
