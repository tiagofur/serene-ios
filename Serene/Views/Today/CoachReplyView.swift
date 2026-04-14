import SwiftUI

struct CoachReplyView: View {
    @Environment(\.colorScheme) private var colorScheme
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            // Coach avatar
            ZStack {
                Circle()
                    .fill(SereneColors.sage(colorScheme))
                    .frame(width: 20, height: 20)
                Image(systemName: "sparkle")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
            }

            Text(text)
                .sereneBody(14)
                .foregroundColor(SereneColors.textSecondary(colorScheme))
                .lineLimit(3)
        }
        .padding(.horizontal, Spacing.sm + 4)
        .padding(.vertical, Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(SereneColors.sageSoft(colorScheme).opacity(0.5))
        )
    }
}

// MARK: - Typing Dots Animation
struct TypingDotsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var animating = false

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            ZStack {
                Circle()
                    .fill(SereneColors.sage(colorScheme))
                    .frame(width: 20, height: 20)
                Image(systemName: "sparkle")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
            }

            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(SereneColors.textTertiary(colorScheme))
                        .frame(width: 6, height: 6)
                        .offset(y: animating ? -4 : 0)
                        .animation(
                            .easeInOut(duration: 0.35)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.12),
                            value: animating
                        )
                }
            }
            .padding(.top, 6)
        }
        .padding(.horizontal, Spacing.sm + 4)
        .padding(.vertical, Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(SereneColors.sageSoft(colorScheme).opacity(0.5))
        )
        .onAppear {
            animating = true
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        CoachReplyView(text: "Qué bonito que notes eso. Los pequeños momentos son los que más cuentan. 🌿")
        TypingDotsView()
    }
    .padding()
}
