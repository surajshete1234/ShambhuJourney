import SwiftUI

/// Shared visual language for the app: soft pastels, warm tones, elegant serif headlines.
enum Theme {
    static let blush = Color(red: 0.98, green: 0.87, blue: 0.86)
    static let lavender = Color(red: 0.89, green: 0.85, blue: 0.96)
    static let cream = Color(red: 0.99, green: 0.96, blue: 0.90)
    static let sky = Color(red: 0.85, green: 0.92, blue: 0.97)
    static let gold = Color(red: 0.85, green: 0.68, blue: 0.40)
    static let deepRose = Color(red: 0.72, green: 0.40, blue: 0.42)
    static let ink = Color(red: 0.20, green: 0.18, blue: 0.20)

    static let milestoneColors: [String: Color] = [
        "blush": blush,
        "lavender": lavender,
        "cream": cream,
        "sky": sky,
        "gold": gold
    ]

    static func color(named name: String) -> Color {
        milestoneColors[name] ?? blush
    }

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [cream, blush.opacity(0.6), lavender.opacity(0.5)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    enum Font {
        static func headline(_ size: CGFloat = 28) -> SwiftUI.Font {
            .system(size: size, weight: .semibold, design: .serif)
        }

        static func body(_ size: CGFloat = 17) -> SwiftUI.Font {
            .system(size: size, weight: .regular, design: .rounded)
        }

        static func caption(_ size: CGFloat = 13) -> SwiftUI.Font {
            .system(size: size, weight: .medium, design: .rounded)
        }
    }
}
