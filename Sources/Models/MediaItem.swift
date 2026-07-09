import Foundation

/// A single photo or video that appears somewhere in the journey.
///
/// A `MediaItem` resolves to actual bytes from one of two places:
/// - `assetName`: a file bundled with the app (in Assets.xcassets for photos, or in the
///   "Media" resource folder for videos and full-resolution photos).
/// - `fileURL`: a file the user imported from their own device, copied into the app's
///   Documents/Media folder so it persists between launches.
struct MediaItem: Identifiable, Hashable, Codable {
    let id: UUID
    let type: MediaType
    var assetName: String?
    var fileURL: URL?
    var caption: String
    var dateTaken: Date?

    init(
        id: UUID = UUID(),
        type: MediaType,
        assetName: String? = nil,
        fileURL: URL? = nil,
        caption: String = "",
        dateTaken: Date? = nil
    ) {
        self.id = id
        self.type = type
        self.assetName = assetName
        self.fileURL = fileURL
        self.caption = caption
        self.dateTaken = dateTaken
    }
}
