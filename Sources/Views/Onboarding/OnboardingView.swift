import SwiftUI

struct OnboardingView: View {
    let onFinish: () -> Void

    @State private var appear = false
    @State private var page = 0

    private let pages: [(title: String, subtitle: String, systemImage: String)] = [
        ("Every Story Has a Beginning", "This one begins with the two of us, and a heartbeat we couldn't wait to meet.", "heart.fill"),
        ("Nine Months of Love", "Every ache, every flutter, every quiet moment of waiting — captured here, forever.", "sparkles"),
        ("Welcome, \(AppConstants.babyName)", "Our family's newest chapter starts now.", "figure.2.and.child.holdinghands")
    ]

    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()
            VStack(spacing: 28) {
                Spacer()

                Image(systemName: pages[page].systemImage)
                    .font(.system(size: 56))
                    .foregroundStyle(Theme.deepRose)
                    .opacity(appear ? 1 : 0)
                    .scaleEffect(appear ? 1 : 0.7)

                Text(pages[page].title)
                    .font(Theme.Font.headline(30))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.ink)
                    .padding(.horizontal, 32)

                Text(pages[page].subtitle)
                    .font(Theme.Font.body())
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.ink.opacity(0.7))
                    .padding(.horizontal, 40)
                    .opacity(appear ? 1 : 0)

                Spacer()

                HStack(spacing: 8) {
                    ForEach(pages.indexedElements) { pair in
                        Capsule()
                            .fill(pair.index == page ? Theme.deepRose : Theme.deepRose.opacity(0.25))
                            .frame(width: pair.index == page ? 22 : 8, height: 8)
                            .animation(.spring(response: 0.4), value: page)
                    }
                }

                Button(action: advance) {
                    Text(page == pages.count - 1 ? "Begin Our Story" : "Continue")
                        .font(Theme.Font.body(18).bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.deepRose, in: Capsule())
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear { withAnimation(.easeOut(duration: 0.8)) { appear = true } }
    }

    private func advance() {
        if page < pages.count - 1 {
            appear = false
            withAnimation(.easeOut(duration: 0.5)) { page += 1 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeOut(duration: 0.8)) { appear = true }
            }
        } else {
            onFinish()
        }
    }
}
