import SwiftUI

struct RootView: View {
    @State private var hasOnboarded = UserDefaults.standard.bool(forKey: "hasOnboarded")
    @State private var journeyVM = JourneyViewModel()

    var body: some View {
        Group {
            if hasOnboarded {
                HomeView(journeyVM: journeyVM)
                    .transition(.opacity)
            } else {
                OnboardingView {
                    UserDefaults.standard.set(true, forKey: "hasOnboarded")
                    withAnimation(.easeInOut(duration: 0.6)) { hasOnboarded = true }
                }
                .transition(.opacity)
            }
        }
    }
}
