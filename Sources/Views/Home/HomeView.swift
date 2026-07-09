import SwiftUI

enum HomeDestination: Hashable {
    case timeline, playStory, babyWelcome, loveMessage
}

struct HomeView: View {
    var journeyVM: JourneyViewModel
    @State private var appear = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()
                ScrollView(showsIndicators: true) {
                    VStack(spacing: 22) {
                        header

                        NavigationLink(value: HomeDestination.timeline) {
                            HomeMenuCard(
                                title: "Our Journey",
                                subtitle: "Every month, every milestone",
                                systemImage: "photo.on.rectangle.angled",
                                color: Theme.blush
                            )
                        }
                        NavigationLink(value: HomeDestination.playStory) {
                            HomeMenuCard(
                                title: "Play Our Story",
                                subtitle: "Sit back and relive it, cinematically",
                                systemImage: "play.circle.fill",
                                color: Theme.lavender
                            )
                        }
                        NavigationLink(value: HomeDestination.babyWelcome) {
                            HomeMenuCard(
                                title: "Meet \(AppConstants.babyName)",
                                subtitle: "Our little miracle has arrived",
                                systemImage: "star.fill",
                                color: Theme.sky
                            )
                        }
                        NavigationLink(value: HomeDestination.loveMessage) {
                            HomeMenuCard(
                                title: "A Letter to \(AppConstants.motherName)",
                                subtitle: "Words from the heart",
                                systemImage: "envelope.fill",
                                color: Theme.gold.opacity(0.5)
                            )
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: HomeDestination.self) { destination in
                switch destination {
                case .timeline: JourneyTimelineView(viewModel: journeyVM)
                case .playStory: PlayStoryView(milestones: journeyVM.milestones)
                case .babyWelcome: BabyWelcomeView()
                case .loveMessage: LoveMessageView()
                }
            }
        }
    }

    private var header: some View {
        VStack(spacing: 6) {
            Text("For \(AppConstants.motherName) & \(AppConstants.babyName)")
                .font(Theme.Font.caption(14))
                .foregroundStyle(Theme.deepRose)
                .textCase(.uppercase)
                .kerning(1.5)
            Text("Our Journey to You")
                .font(Theme.Font.headline(32))
                .foregroundStyle(Theme.ink)
        }
        .padding(.top, 24)
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 12)
        .onAppear { withAnimation(.easeOut(duration: 0.7)) { appear = true } }
    }
}

private struct HomeMenuCard: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle().fill(color).frame(width: 54, height: 54)
                Image(systemName: systemImage)
                    .foregroundStyle(Theme.deepRose)
                    .font(.system(size: 22, weight: .medium))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(Theme.Font.body(19).bold()).foregroundStyle(Theme.ink)
                Text(subtitle).font(Theme.Font.caption()).foregroundStyle(Theme.ink.opacity(0.6))
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.ink.opacity(0.3))
        }
        .padding(18)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.4), lineWidth: 1))
        .shadow(color: Theme.ink.opacity(0.06), radius: 12, y: 6)
    }
}
