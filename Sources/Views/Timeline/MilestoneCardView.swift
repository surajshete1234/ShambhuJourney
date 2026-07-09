import PhotosUI
import SwiftUI

struct MilestoneCardView: View {
    let milestone: JourneyMilestone
    let index: Int
    var viewModel: JourneyViewModel

    @State private var selectedMediaIndex: Int?
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(milestone.subtitle.uppercased())
                    .font(Theme.Font.caption())
                    .kerning(1.2)
                    .foregroundStyle(Theme.deepRose)
                Spacer()
                PhotosPicker(selection: $pickerItem, matching: .any(of: [.images, .videos])) {
                    Image(systemName: "plus.circle")
                        .foregroundStyle(Theme.deepRose)
                }
                Text(milestone.date.formatted(.dateTime.month(.wide).year()))
                    .font(Theme.Font.caption())
                    .foregroundStyle(Theme.ink.opacity(0.5))
            }

            Text(milestone.title)
                .font(Theme.Font.headline(24))
                .foregroundStyle(Theme.ink)

            if let hero = milestone.media.first {
                ParallaxImageView(item: hero)
                    .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                    .onTapGesture { selectedMediaIndex = 0 }
            }

            Text(milestone.story)
                .font(Theme.Font.body())
                .foregroundStyle(Theme.ink.opacity(0.75))
                .lineSpacing(4)

            if milestone.media.count > 1 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(Array(milestone.media.dropFirst().enumerated()), id: \.element.id) { offset, item in
                            MediaThumbnailView(item: item)
                                .frame(width: 90, height: 90)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .onTapGesture { selectedMediaIndex = offset + 1 }
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(.white.opacity(0.55), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Theme.color(named: milestone.accentColorName).opacity(0.5), lineWidth: 1)
        )
        .shadow(color: Theme.ink.opacity(0.05), radius: 14, y: 8)
        .fullScreenCover(item: selectedMediaIndexBinding) { wrapper in
            FullScreenMediaViewer(media: milestone.media, startIndex: wrapper.value)
        }
        .onChange(of: pickerItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let imported = await MediaLibraryService.importPickerItem(newItem) {
                    viewModel.addImportedMedia(imported, to: milestone.id)
                }
                pickerItem = nil
            }
        }
    }

    private var selectedMediaIndexBinding: Binding<IndexWrapper?> {
        Binding(
            get: { selectedMediaIndex.map { IndexWrapper(value: $0) } },
            set: { selectedMediaIndex = $0?.value }
        )
    }
}

private struct IndexWrapper: Identifiable {
    let value: Int
    var id: Int { value }
}
