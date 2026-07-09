import SwiftUI

struct JourneyTimelineView: View {
    var viewModel: JourneyViewModel
    @State private var appearedIDs: Set<UUID> = []

    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.milestones.enumerated()), id: \.element.id) { index, milestone in
                        MilestoneCardView(milestone: milestone, index: index, viewModel: viewModel)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 28)
                            .opacity(appearedIDs.contains(milestone.id) ? 1 : 0)
                            .offset(y: appearedIDs.contains(milestone.id) ? 0 : 40)
                            .onAppear {
                                withAnimation(.easeOut(duration: 0.6)) {
                                    appearedIDs.insert(milestone.id)
                                }
                            }
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Our Journey")
        .navigationBarTitleDisplayMode(.large)
    }
}
