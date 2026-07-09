import SwiftUI
import UIKit

/// Auto-playing, movie-like retelling of the whole journey: Ken Burns zoom on photos,
/// real playback for videos, captions, background music, and an export-to-video option.
struct PlayStoryView: View {
    private let milestones: [JourneyMilestone]
    @State private var viewModel: StoryPlayerViewModel
    @State private var exportService = VideoExportService()
    @State private var exportedURL: URL?
    @State private var showShareSheet = false
    @State private var exportErrorMessage: String?
    @Environment(\.dismiss) private var dismiss

    init(milestones: [JourneyMilestone]) {
        self.milestones = milestones
        _viewModel = State(initialValue: StoryPlayerViewModel(milestones: milestones))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let scene = viewModel.currentScene {
                SceneView(scene: scene, viewModel: viewModel)
                    .id(scene.id)
                    .transition(.opacity.combined(with: .scale(scale: 1.03)))
            }

            VStack {
                topBar
                Spacer()
                caption
                progressBar
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                controls
                    .padding(.vertical, 24)
            }
        }
        .statusBarHidden()
        .onAppear { viewModel.start() }
        .onDisappear { viewModel.stop() }
        .sheet(isPresented: $showShareSheet) {
            if let exportedURL {
                ShareSheet(items: [exportedURL])
            }
        }
        .alert("Export Failed", isPresented: .constant(exportErrorMessage != nil)) {
            Button("OK") { exportErrorMessage = nil }
        } message: {
            Text(exportErrorMessage ?? "")
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: { viewModel.stop(); dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(.ultraThinMaterial, in: Circle())
            }
            Spacer()
            Button(action: exportVideo) {
                Group {
                    if exportService.isExporting {
                        ProgressView().tint(.white)
                    } else {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(.white)
                    }
                }
                .padding(10)
                .background(.ultraThinMaterial, in: Circle())
            }
            .disabled(exportService.isExporting)
        }
        .padding()
    }

    @ViewBuilder
    private var caption: some View {
        if let scene = viewModel.currentScene, !scene.caption.isEmpty {
            Text(scene.caption)
                .font(Theme.Font.headline(22))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .shadow(radius: 8)
                .transition(.opacity)
                .id(scene.id)
        }
    }

    private var progressBar: some View {
        HStack(spacing: 4) {
            ForEach(viewModel.scenes.indices, id: \.self) { i in
                Capsule()
                    .fill(i <= viewModel.currentIndex ? Color.white : Color.white.opacity(0.25))
                    .frame(height: 3)
            }
        }
    }

    private var controls: some View {
        HStack(spacing: 40) {
            Button(action: viewModel.previous) {
                Image(systemName: "backward.fill").foregroundStyle(.white).font(.title3)
            }
            Button(action: { viewModel.isPlaying ? viewModel.pause() : viewModel.resume() }) {
                Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 46))
                    .foregroundStyle(.white)
            }
            Button(action: viewModel.next) {
                Image(systemName: "forward.fill").foregroundStyle(.white).font(.title3)
            }
        }
    }

    private func exportVideo() {
        Task {
            do {
                let url = try await exportService.exportJourney(milestones: milestones)
                exportedURL = url
                showShareSheet = true
            } catch {
                exportErrorMessage = "Couldn't export the video. Please try again on a real device."
            }
        }
    }
}

private struct SceneView: View {
    let scene: StoryPlayerViewModel.Scene
    var viewModel: StoryPlayerViewModel
    @State private var uiImage: UIImage?
    @State private var zoomed = false

    var body: some View {
        GeometryReader { geo in
            Group {
                if scene.media.type == .video, let url = MediaLibraryService.videoURL(for: scene.media) {
                    VideoPlayerView(url: url) {
                        viewModel.next()
                    }
                } else if let uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .scaleEffect(zoomed ? 1.12 : 1.0)
                        .animation(.easeInOut(duration: 4.5), value: zoomed)
                        .onAppear { zoomed = true }
                } else {
                    ProgressView().tint(.white)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
        .ignoresSafeArea()
        .task(id: scene.id) {
            if scene.media.type == .photo {
                uiImage = await MediaCacheService.shared.image(for: scene.media)
            }
        }
    }
}
