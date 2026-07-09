import Foundation

/// One chapter of the pregnancy journey — typically a month, but also used for
/// special one-off milestones like the arrival itself.
struct JourneyMilestone: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var subtitle: String
    var story: String
    var date: Date
    var media: [MediaItem]
    /// Key into `Theme.milestoneColors`, keeps the model UI-framework-agnostic and Codable.
    var accentColorName: String

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        story: String,
        date: Date,
        media: [MediaItem],
        accentColorName: String = "blush"
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.story = story
        self.date = date
        self.media = media
        self.accentColorName = accentColorName
    }
}
