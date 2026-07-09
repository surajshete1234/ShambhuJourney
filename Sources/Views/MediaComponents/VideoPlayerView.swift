import AVKit
import SwiftUI

/// Thin AVKit wrapper used everywhere the app plays a video clip.
struct VideoPlayerView: View {
    let url: URL
    var autoPlay: Bool = true
    var onFinished: (() -> Void)?

    @State private var player: AVPlayer?

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                let newPlayer = AVPlayer(url: url)
                player = newPlayer
                if autoPlay { newPlayer.play() }
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: newPlayer.currentItem,
                    queue: .main
                ) { _ in
                    onFinished?()
                }
            }
            .onDisappear {
                player?.pause()
            }
    }
}
