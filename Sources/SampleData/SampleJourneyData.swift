import Foundation

/// Dummy placeholder journey so the app is fully browsable out of the box.
/// Replace `assetName` values with your real files — see README_SETUP.md for the
/// exact naming convention, or use the in-app "+" import button on any milestone card.
enum SampleJourneyData {
    static var milestones: [JourneyMilestone] {
        [
            JourneyMilestone(
                title: "Month 1 · The Beginning",
                subtitle: "Weeks 1–4",
                story: "The moment we found out. Two lines that changed everything.",
                date: dateFor(monthsBeforeBirth: 9),
                media: [MediaItem(type: .photo, assetName: "month1_test", caption: "The two lines that started it all")],
                accentColorName: "blush"
            ),
            JourneyMilestone(
                title: "Month 2 · First Heartbeat",
                subtitle: "Weeks 5–8",
                story: "We heard it for the first time — fast, tiny, and unmistakably alive.",
                date: dateFor(monthsBeforeBirth: 8),
                media: [MediaItem(type: .photo, assetName: "month2_scan", caption: "First ultrasound")],
                accentColorName: "lavender"
            ),
            JourneyMilestone(
                title: "Month 3 · Our Secret",
                subtitle: "Weeks 9–12",
                story: "Just the two of us knew. Quiet excitement, morning sickness, and so much hope.",
                date: dateFor(monthsBeforeBirth: 7),
                media: [MediaItem(type: .photo, assetName: "month3_bump", caption: "A little bump begins")],
                accentColorName: "cream"
            ),
            JourneyMilestone(
                title: "Month 4 · Telling the World",
                subtitle: "Weeks 13–16",
                story: "We finally shared our joy with family and friends.",
                date: dateFor(monthsBeforeBirth: 6),
                media: [MediaItem(type: .photo, assetName: "month4_announcement", caption: "Sharing the news")],
                accentColorName: "sky"
            ),
            JourneyMilestone(
                title: "Month 5 · First Kicks",
                subtitle: "Weeks 17–20",
                story: "You felt him move for the first time, and nothing was ever the same.",
                date: dateFor(monthsBeforeBirth: 5),
                media: [MediaItem(type: .video, assetName: "month5_kicks", caption: "First flutters")],
                accentColorName: "gold"
            ),
            JourneyMilestone(
                title: "Month 6 · Growing Strong",
                subtitle: "Weeks 21–24",
                story: "The bump grew, and so did our love for the little one inside.",
                date: dateFor(monthsBeforeBirth: 4),
                media: [MediaItem(type: .photo, assetName: "month6_bump", caption: "Growing every day")],
                accentColorName: "blush"
            ),
            JourneyMilestone(
                title: "Month 7 · Nursery Dreams",
                subtitle: "Weeks 25–28",
                story: "We prepared his little corner of the world with so much love.",
                date: dateFor(monthsBeforeBirth: 3),
                media: [MediaItem(type: .photo, assetName: "month7_nursery", caption: "Getting his room ready")],
                accentColorName: "lavender"
            ),
            JourneyMilestone(
                title: "Month 8 · Almost There",
                subtitle: "Weeks 29–32",
                story: "Anticipation, love, and a nursery full of hope.",
                date: dateFor(monthsBeforeBirth: 2),
                media: [MediaItem(type: .photo, assetName: "month8_bump", caption: "So close now")],
                accentColorName: "cream"
            ),
            JourneyMilestone(
                title: "Month 9 · The Final Wait",
                subtitle: "Weeks 33–40",
                story: "Every day felt like a lifetime. We were ready to meet you.",
                date: dateFor(monthsBeforeBirth: 1),
                media: [MediaItem(type: .photo, assetName: "month9_bump", caption: "Any day now")],
                accentColorName: "sky"
            ),
            JourneyMilestone(
                title: "Shambhu's Arrival",
                subtitle: "The Day Our World Changed",
                story: "Vishakha's strength brought our son into the world. Welcome, Shambhu.",
                date: AppConstants.babyBirthDate,
                media: [MediaItem(type: .photo, assetName: "shambhu_arrival", caption: "Our baby boy is here")],
                accentColorName: "gold"
            )
        ]
    }

    private static func dateFor(monthsBeforeBirth: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: -monthsBeforeBirth, to: AppConstants.babyBirthDate) ?? Date()
    }
}
