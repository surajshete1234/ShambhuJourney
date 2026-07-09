# Shambhu's Journey — Setup Guide

A native SwiftUI iOS app celebrating Vishakha's pregnancy journey and Shambhu's arrival.
This project was generated on Windows, so it has **not** been compiled in Xcode — follow
this guide on a Mac to build, add your real media, and run it.

## Requirements

- macOS with **Xcode 15 or later** (targets iOS 17+, uses the `@Observable` macro and
  `PhotosPicker`)
- A Mac (Xcode does not run on Windows)
- Optional: [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`) —
  the recommended way to turn this source tree into an `.xcodeproj`

## Option A — Generate the project with XcodeGen (recommended)

1. Copy this whole `ShambhuJourney` folder to your Mac.
2. Install XcodeGen once: `brew install xcodegen`
3. From inside the `ShambhuJourney` folder, run:
   ```
   xcodegen generate
   ```
4. Open `ShambhuJourney.xcodeproj` in Xcode.
5. Select your Team under **Signing & Capabilities** (needed to run on a real device).
6. Build & run (⌘R) on a simulator or device.

## Option B — Manual Xcode project

1. In Xcode: **File → New → Project → iOS → App**. Name it `ShambhuJourney`, interface
   **SwiftUI**, minimum deployment target **iOS 17**.
2. Delete the default `ContentView.swift` and generated `Assets.xcassets`.
3. Drag the `Sources` and `Resources` folders from this project into your new Xcode
   project (check "Copy items if needed" and "Create groups").
4. Replace the auto-generated `Info.plist` with `Sources/Supporting/Info.plist`, or merge
   in its `NSPhotoLibraryUsageDescription` / `NSPhotoLibraryAddUsageDescription` keys.
5. Build & run.

## Adding your real photos and videos

The app ships with a full 10-milestone sample journey so every screen is browsable
immediately, but every photo is a placeholder. Two ways to swap in the real thing:

**Before building** — drop files into `Resources/Media/` using the exact names listed in
`Resources/Media/PUT_YOUR_PHOTOS_AND_VIDEOS_HERE.md` (they match what
`Sources/SampleData/SampleJourneyData.swift` expects). Re-run `xcodegen generate` if using
Option A.

**From inside the app** — every milestone card on the "Our Journey" timeline has a **+**
button that opens the system Photos picker and imports directly from your device. No
rebuild needed; imported files are copied into the app's Documents folder so they persist.

To add more milestones, more months, or change the story text, edit
`Sources/SampleData/SampleJourneyData.swift` directly — it's a plain Swift array.

## Adding background music

Drop an mp3 named `story_theme.mp3` into `Resources/Audio/` (see the README in that
folder). It's used both during "Play Our Story" and mixed into exported videos. Make sure
you have the rights to use whatever track you choose.

## Personalizing names & dates

Edit `Sources/Utilities/AppConstants.swift`:

```swift
static let babyBirthDate = ...   // Shambhu's real date of birth
static let babyName = "Shambhu"
static let motherName = "Vishakha"
static let fatherName = "Suraj"
```

The heartfelt letter text itself lives verbatim in
`Sources/Views/LoveMessage/LoveMessageView.swift` if you ever want to edit the wording.

## App icon

`Resources/Assets.xcassets/AppIcon.appiconset` is set up for the modern single 1024×1024
icon format — drag your icon image onto the empty slot in Xcode's asset editor.

## Architecture (MVVM)

```
Sources/
  App/            Entry point + RootView (onboarding gate)
  Models/         MediaType, MediaItem, JourneyMilestone (Codable value types)
  ViewModels/      JourneyViewModel, StoryPlayerViewModel (@Observable)
  Views/
    Onboarding/    First-launch welcome flow
    Home/          Navigation hub (NavigationStack)
    Timeline/      "Our Journey" — parallax milestone cards
    MediaComponents/  Reusable image/video/thumbnail/full-screen viewer components
    StoryMode/     "Play Our Story" — cinematic auto-play with Ken Burns + music
    BabyWelcome/   Shambhu's animated welcome screen
    LoveMessage/   The letter to Vishakha
  Services/        MediaCacheService (image cache), MediaLibraryService (file
                   resolution + Photos import), AudioPlayerService (background
                   music), VideoExportService (stitches the journey into an
                   exportable .mov)
  Utilities/       Theme (pastel palette, typography), AppConstants
  SampleData/      Dummy 10-milestone journey
```

## Notes on the video export feature

`VideoExportService` renders photos into short silent clips (via `AVAssetWriter`) and
splices them together with any real video clips and the background music using
`AVMutableComposition` + `AVAssetExportSession`. This is genuinely more involved than the
rest of the app and is best tested on a real device with real media — the simulator's
video pipeline can be flaky. If export fails, the app shows a friendly alert rather than
crashing.

## Known limitations

- Because this was generated without access to Xcode, it has not been compile-verified.
  The code follows current SwiftUI/iOS 17 APIs carefully, but budget time for a first
  build to shake out any environment-specific issues (missing Team ID, asset catalog
  quirks, etc.).
- No unit tests are included — the priority was the emotional, visual experience end to
  end. Happy to add a test target if you want one.
