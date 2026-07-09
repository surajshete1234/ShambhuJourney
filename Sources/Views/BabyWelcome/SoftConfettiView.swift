import SwiftUI

/// Gentle falling-particle celebration effect, used behind the baby welcome screen.
struct SoftConfettiView: View {
    let trigger: Int
    @State private var particles: [ConfettiParticle] = []

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for particle in particles {
                    let progress = particle.progress(at: timeline.date)
                    guard progress < 1 else { continue }
                    let x = particle.startX * size.width
                    let y = progress * size.height
                    var resolved = context
                    resolved.opacity = 1 - progress
                    resolved.fill(
                        Path(ellipseIn: CGRect(x: x, y: y, width: particle.size, height: particle.size)),
                        with: .color(particle.color)
                    )
                }
            }
        }
        .allowsHitTesting(false)
        .onAppear { spawn() }
        .onChange(of: trigger) { _, _ in spawn() }
    }

    private func spawn() {
        let colors: [Color] = [Theme.gold, Theme.deepRose, Theme.lavender, Theme.sky]
        particles = (0..<40).map { _ in
            ConfettiParticle(
                startX: Double.random(in: 0...1),
                size: CGFloat.random(in: 4...9),
                color: colors.randomElement() ?? Theme.gold,
                startDate: Date(),
                duration: Double.random(in: 3...5)
            )
        }
    }
}

private struct ConfettiParticle {
    let startX: Double
    let size: CGFloat
    let color: Color
    let startDate: Date
    let duration: Double

    func progress(at date: Date) -> Double {
        min(1, date.timeIntervalSince(startDate) / duration)
    }
}
