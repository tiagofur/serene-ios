import SwiftUI

struct GratitudeSlotView: View {
    let index: Int
    let gratitude: Gratitude?
    let isExtra: Bool
    let onTap: () -> Void

    private var isCompleted: Bool { gratitude != nil }
    private var prompt: String { Gratitude.prompt(for: index, isExtra: isExtra) }
    private var slotLabel: String {
        isExtra ? "Extra \(index + 1)" : "Gratitud \(index + 1)"
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                // Check / number indicator
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 18, height: 18)
                        .background(Color.sage)
                        .clipShape(Circle())
                } else {
                    Text("\(isExtra ? index + 4 : index + 1)")
                        .font(.labelSmall)
                        .foregroundStyle(Color.textTertiary)
                        .frame(width: 18, height: 18)
                }

                VStack(alignment: .leading, spacing: Spacing.xs) {
                    if let gratitude {
                        Text(gratitude.text)
                            .font(.body)
                            .foregroundStyle(Color.textPrimary)
                            .lineLimit(2)

                        if let response = gratitude.aiResponse {
                            CoachReplyBubble(text: response)
                        }
                    } else {
                        Text(prompt)
                            .font(.body)
                            .foregroundStyle(Color.textTertiary)
                    }
                }

                Spacer()

                if isExtra && !isCompleted {
                    Text("Extra")
                        .font(.micro)
                        .foregroundStyle(Color.arena)
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, Spacing.xs)
                        .background(Color.arenaSoft)
                        .clipShape(Capsule())
                }
            }
            .padding(13)
            .background(
                isCompleted ? Color.surface : Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .stroke(
                        isExtra ? Color.arena : Color.borderDefault,
                        style: isCompleted
                            ? StrokeStyle(lineWidth: BorderWidth.default)
                            : StrokeStyle(lineWidth: BorderWidth.emphasis, dash: [6, 4])
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
