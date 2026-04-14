import SwiftUI

struct StreakCardView: View {
    @Environment(\.colorScheme) private var colorScheme
    let currentStreak: Int
    let weekDots: [WeekDotState]

    @State private var streakPopped = false

    var body: some View {
        VStack(spacing: Spacing.md) {
            HStack(spacing: Spacing.md) {
                // Streak icon
                ZStack {
                    RoundedRectangle(cornerRadius: Radius.md)
                        .fill(SereneColors.sageSoft(colorScheme))
                        .frame(width: 36, height: 36)
                    Image(systemName: "flame.fill")
                        .font(.system(size: 18))
                        .foregroundColor(SereneColors.sage(colorScheme))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(currentStreak)")
                        .sereneHeading(20)
                        .foregroundColor(SereneColors.sage(colorScheme))
                        .scaleEffect(streakPopped ? 1.25 : 1.0)

                    Text(currentStreak == 1 ? "día de racha" : "días de racha")
                        .sereneMicro()
                        .foregroundColor(SereneColors.textTertiary(colorScheme))
                }

                Spacer()
            }

            // Week dots
            HStack(spacing: Spacing.sm) {
                ForEach(0..<7, id: \.self) { index in
                    if index < weekDots.count {
                        weekDot(state: weekDots[index])
                    } else {
                        weekDot(state: .empty)
                    }
                }
            }
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(SereneColors.surface(colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(SereneColors.borderDefault(colorScheme), lineWidth: BorderWidth.default)
                )
        )
        .onChange(of: currentStreak) { _, _ in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                streakPopped = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    streakPopped = false
                }
            }
        }
    }

    @ViewBuilder
    private func weekDot(state: WeekDotState) -> some View {
        Circle()
            .fill(dotFill(for: state))
            .overlay(
                Circle()
                    .stroke(dotStroke(for: state), lineWidth: state == .empty ? 1 : 0)
            )
            .frame(width: 8, height: 8)
    }

    private func dotFill(for state: WeekDotState) -> Color {
        switch state {
        case .done: return SereneColors.sage(colorScheme)
        case .today: return SereneColors.arena(colorScheme)
        case .empty: return .clear
        }
    }

    private func dotStroke(for state: WeekDotState) -> Color {
        switch state {
        case .empty: return SereneColors.borderDefault(colorScheme)
        default: return .clear
        }
    }
}

#Preview {
    StreakCardView(
        currentStreak: 5,
        weekDots: [.done, .done, .done, .done, .done, .today, .empty]
    )
    .padding()
}
