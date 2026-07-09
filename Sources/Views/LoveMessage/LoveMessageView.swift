import SwiftUI

/// A heartfelt letter, revealed paragraph by paragraph with gentle fades.
struct LoveMessageView: View {
    private let paragraphs = [
        "Vishakha,",
        "Thank you for everything you went through during this beautiful journey. I have seen your strength, your patience, and the pain you endured, and I am incredibly proud of you.",
        "You are not just an amazing wife but the strongest mother.",
        "I am truly blessed to have you in my life.",
        "Our baby boy Shambhu is lucky to have you.",
        "I love you more than words can ever express."
    ]

    @State private var visibleCount = 0
    @State private var signatureVisible = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.cream, Theme.blush.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView(showsIndicators: true) {
                VStack(alignment: .leading, spacing: 22) {
                    Image(systemName: "heart.fill")
                        .font(.title)
                        .foregroundStyle(Theme.deepRose)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 30)

                    ForEach(Array(paragraphs.enumerated()), id: \.offset) { index, text in
                        Text(text)
                            .font(index == 0 ? Theme.Font.headline(26) : Theme.Font.body(19))
                            .foregroundStyle(Theme.ink)
                            .lineSpacing(6)
                            .opacity(visibleCount > index ? 1 : 0)
                            .offset(y: visibleCount > index ? 0 : 10)
                    }

                    Text("— \(AppConstants.fatherName)")
                        .font(Theme.Font.headline(22))
                        .foregroundStyle(Theme.deepRose)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .opacity(signatureVisible ? 1 : 0)
                        .padding(.top, 10)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 60)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { revealNext() }
    }

    private func revealNext() {
        guard visibleCount < paragraphs.count else {
            withAnimation(.easeIn(duration: 1.0)) { signatureVisible = true }
            return
        }
        withAnimation(.easeOut(duration: 0.9)) {
            visibleCount += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            revealNext()
        }
    }
}
