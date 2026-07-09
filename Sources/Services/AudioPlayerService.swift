import AVFoundation

/// Plays the bundled background music track during Play Story mode, with gentle fades
/// so the music never starts or stops abruptly.
@Observable
final class AudioPlayerService: NSObject {
    static let shared = AudioPlayerService()

    private var player: AVAudioPlayer?
    private var fadeTimer: Timer?
    var isPlaying = false

    private override init() {
        super.init()
    }

    func play(trackNamed name: String, loop: Bool = true, fadeDuration: TimeInterval = 1.5) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3")
            ?? Bundle.main.url(forResource: name, withExtension: "m4a") else {
            // No bundled track yet — story mode still works silently.
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.numberOfLoops = loop ? -1 : 0
            newPlayer.volume = 0
            newPlayer.prepareToPlay()
            newPlayer.play()
            player = newPlayer
            isPlaying = true
            fade(to: 0.55, duration: fadeDuration)
        } catch {
            // Ignore — music is a nice-to-have, not a blocker.
        }
    }

    func stop(fadeDuration: TimeInterval = 1.0) {
        fade(to: 0, duration: fadeDuration) { [weak self] in
            self?.player?.stop()
            self?.player = nil
            self?.isPlaying = false
        }
    }

    func setMuted(_ muted: Bool) {
        fade(to: muted ? 0 : 0.55, duration: 0.3)
    }

    private func fade(to targetVolume: Float, duration: TimeInterval, completion: (() -> Void)? = nil) {
        fadeTimer?.invalidate()
        guard let player else {
            completion?()
            return
        }
        let steps = 20
        let stepDuration = duration / Double(steps)
        let startVolume = player.volume
        let delta = (targetVolume - startVolume) / Float(steps)
        var currentStep = 0

        fadeTimer = Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { timer in
            currentStep += 1
            player.volume = startVolume + delta * Float(currentStep)
            if currentStep >= steps {
                timer.invalidate()
                completion?()
            }
        }
    }
}
