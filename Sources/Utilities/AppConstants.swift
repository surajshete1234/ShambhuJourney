import Foundation

/// Central place to personalize the app. Edit these to match real dates and names.
enum AppConstants {
    /// TODO: Replace with Shambhu's real date of birth.
    static let babyBirthDate = Calendar.current.date(from: DateComponents(year: 2026, month: 7, day: 1)) ?? Date()

    static let babyName = "Shambhu"
    static let motherName = "Vishakha"
    static let fatherName = "Suraj"

    /// File name (without extension) of the bundled background music track used during
    /// Play Story mode and video export. Drop an mp3/m4a with this name into Resources/Audio.
    static let storyMusicTrackName = "story_theme"
}
