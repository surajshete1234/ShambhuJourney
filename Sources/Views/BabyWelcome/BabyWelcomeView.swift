import SwiftUI

struct BabyWelcomeView: View {
    @State private var showName = false
    @State private var showDetails = false
    @State private var floatUp = false
    @State private var confettiTrigger = 0

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.sky, Theme.cream, Theme.blush], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            SoftConfettiView(trigger: confettiTrigger)

            VStack(spacing: 20) {
                Spacer()

                Text("WELCOME TO THE WORLD")
                    .font(Theme.Font.caption(14))
                    .kerning(2)
                    .foregroundStyle(Theme.deepRose)
                    .opacity(showName ? 1 : 0)

                Text(AppConstants.babyName)
                    .font(.system(size: 64, weight: .bold, design: .serif))
                    .foregroundStyle(Theme.ink)
                    .scaleEffect(showName ? 1 : 0.6)
                    .opacity(showName ? 1 : 0)

                Image(systemName: "sparkles")
                    .font(.title)
                    .foregroundStyle(Theme.gold)
                    .opacity(showDetails ? 1 : 0)

                Text("Our little miracle, wrapped in love,\nchosen for our family by fate above.")
                    .font(Theme.Font.body(18))
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.ink.opacity(0.8))
                    .padding(.horizontal, 40)
                    .opacity(showDetails ? 1 : 0)
                    .offset(y: showDetails ? 0 : 14)

                Spacer()

                VStack(spacing: 6) {
                    Text("Son of \(AppConstants.fatherName) & \(AppConstants.motherName)")
                        .font(Theme.Font.caption())
                        .foregroundStyle(Theme.ink.opacity(0.6))
                    Text(AppConstants.babyBirthDate.formatted(.dateTime.day().month(.wide).year()))
                        .font(Theme.Font.caption())
                        .foregroundStyle(Theme.ink.opacity(0.4))
                }
                .opacity(showDetails ? 1 : 0)
                .padding(.bottom, 50)
            }
            .offset(y: floatUp ? -6 : 6)
            .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: floatUp)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) { showName = true }
            withAnimation(.easeOut(duration: 0.8).delay(0.5)) { showDetails = true }
            floatUp = true
            confettiTrigger += 1
        }
    }
}
