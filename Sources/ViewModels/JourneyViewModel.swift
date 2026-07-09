import Foundation

@Observable
final class JourneyViewModel {
    var milestones: [JourneyMilestone]

    init(milestones: [JourneyMilestone] = SampleJourneyData.milestones) {
        self.milestones = milestones.sorted { $0.date < $1.date }
    }

    var allMedia: [MediaItem] {
        milestones.flatMap { $0.media }
    }

    func addImportedMedia(_ item: MediaItem, to milestoneID: UUID) {
        guard let index = milestones.firstIndex(where: { $0.id == milestoneID }) else { return }
        milestones[index].media.append(item)
    }
}
