import Foundation

/// Drives "Play Story" mode: a flat, chronological list of scenes (one per media item)
/// that auto-advances like a movie. Photo scenes advance on a timer; video scenes advance
/// when `PlayStoryView` reports that AVPlayer finished playback.
@Observable
final class StoryPlayerViewModel {
    struct Scene: Identifiable {
        let id = UUID()
        let media: MediaItem
        let caption: String
    }

    private(set) var scenes: [Scene]
    var currentIndex: Int = 0
    var isPlaying: Bool = false

    private var timer: Timer?
    private let photoDuration: TimeInterval = 4.5

    init(milestones: [JourneyMilestone]) {
        self.scenes = milestones.flatMap { milestone in
            milestone.media.map { Scene(media: $0, caption: milestone.title) }
        }
    }

    var currentScene: Scene? {
        scenes.indices.contains(currentIndex) ? scenes[currentIndex] : nil
    }

    func start() {
        guard !scenes.isEmpty else { return }
        isPlaying = true
        AudioPlayerService.shared.play(trackNamed: AppConstants.storyMusicTrackName)
        scheduleAdvance()
    }

    func pause() {
        isPlaying = false
        timer?.invalidate()
        AudioPlayerService.shared.setMuted(true)
    }

    func resume() {
        isPlaying = true
        AudioPlayerService.shared.setMuted(false)
        scheduleAdvance()
    }

    func stop() {
        isPlaying = false
        timer?.invalidate()
        currentIndex = 0
        AudioPlayerService.shared.stop()
    }

    func next() {
        guard currentIndex < scenes.count - 1 else {
            stop()
            return
        }
        currentIndex += 1
        restartTimerIfNeeded()
    }

    func previous() {
        currentIndex = max(0, currentIndex - 1)
        restartTimerIfNeeded()
    }

    private func restartTimerIfNeeded() {
        guard isPlaying else { return }
        scheduleAdvance()
    }

    private func scheduleAdvance() {
        timer?.invalidate()
        guard let scene = currentScene, scene.media.type == .photo else {
            // Video scenes advance via PlayStoryView observing AVPlayer's end-of-playback notification.
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: photoDuration, repeats: false) { [weak self] _ in
            self?.next()
        }
    }
}
