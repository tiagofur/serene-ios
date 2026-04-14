import SwiftUI

enum GratitudeSlotState {
    case empty
    case active
    case done
    case extraLocked
    case extraUnlocked
}

struct GratitudeSlotView: View {
    @Environment(\.colorScheme) private var colorScheme
    let index: Int
    let entry: GratitudeEntry?
    let state: GratitudeSlotState
    let onTap: () -> Void

    private var slotLabel: String {
        if index < 3 {
            return "Gratitud \(index + 1)"
        } else {
            return "Extra \(index - 2)"
        }
    }

    private var promptText: String {
        switch index {
        case 0, 1, 2: return "Hoy agradezco..."
        case 3: return "¿Qué te sorprendió hoy?"
        case 4: return "¿A quién agradeces y no se lo has dicho?"
        default: return "Hoy agradezco..."
        }
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: Spacing.sm) {
                switch state {
                case .done:
                    doneContent
                case .active:
                    activeContent
                case .empty:
                    emptyContent
                case .extraLocked:
                    lockedContent
                case .extraUnlocked:
                    extraUnlockedContent
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, 13)
            .background(slotBackground)
            .overlay(slotBorder)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Done State
    private var doneContent: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text(slotLabel)
                    .sereneLabel()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
                Spacer()
                if let emoji = entry?.emoji, !emoji.isEmpty {
                    Text(emoji)
                        .font(.system(size: 14))
                }
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(SereneColors.sage(colorScheme))
            }

            if let text = entry?.text {
                Text(text)
                    .sereneBody()
                    .foregroundColor(SereneColors.textPrimary(colorScheme))
                    .lineLimit(2)
            }

            if let response = entry?.aiResponse, !response.isEmpty {
                CoachReplyView(text: response)
            }
        }
    }

    // MARK: - Active State
    private var activeContent: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(slotLabel)
                    .sereneLabel()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
                Text(promptText)
                    .sereneBody()
                    .foregroundColor(SereneColors.textSecondary(colorScheme))
            }
            Spacer()
            Image(systemName: "pencil.circle")
                .font(.system(size: 22))
                .foregroundColor(SereneColors.sage(colorScheme))
        }
    }

    // MARK: - Empty State
    private var emptyContent: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(slotLabel)
                    .sereneLabel()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
                Text(promptText)
                    .sereneBody()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
            }
            Spacer()
        }
    }

    // MARK: - Locked Extra State
    private var lockedContent: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(slotLabel)
                    .sereneLabel()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
                Text("Completa tus 3 gratitudes para desbloquear")
                    .sereneBody()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
            }
            Spacer()
            Image(systemName: "lock.fill")
                .font(.system(size: 22))
                .foregroundColor(SereneColors.borderDefault(colorScheme))
        }
    }

    // MARK: - Extra Unlocked State
    private var extraUnlockedContent: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                HStack(spacing: Spacing.xs) {
                    Text(slotLabel)
                        .sereneLabel()
                        .foregroundColor(SereneColors.arena(colorScheme))
                    Text("EXTRA")
                        .sereneMicro()
                        .foregroundColor(SereneColors.arena(colorScheme))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(SereneColors.arenaSoft(colorScheme))
                        )
                }
                Text(promptText)
                    .sereneBody()
                    .foregroundColor(SereneColors.textSecondary(colorScheme))
            }
            Spacer()
            Image(systemName: "sparkles")
                .font(.system(size: 22))
                .foregroundColor(SereneColors.arena(colorScheme))
        }
    }

    // MARK: - Background & Border
    private var slotBackground: some View {
        Group {
            switch state {
            case .done:
                RoundedRectangle(cornerRadius: Radius.lg)
                    .fill(SereneColors.surface(colorScheme))
            case .extraUnlocked:
                RoundedRectangle(cornerRadius: Radius.lg)
                    .fill(SereneColors.surface(colorScheme))
            default:
                RoundedRectangle(cornerRadius: Radius.lg)
                    .fill(Color.clear)
            }
        }
    }

    private var slotBorder: some View {
        Group {
            switch state {
            case .active:
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(SereneColors.sage(colorScheme), lineWidth: BorderWidth.emphasis)
            case .empty:
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(SereneColors.borderDefault(colorScheme), style: StrokeStyle(lineWidth: BorderWidth.emphasis, dash: [6, 4]))
            case .done:
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(SereneColors.borderDefault(colorScheme), lineWidth: BorderWidth.default)
            case .extraLocked:
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(SereneColors.borderDefault(colorScheme), style: StrokeStyle(lineWidth: BorderWidth.emphasis, dash: [6, 4]))
            case .extraUnlocked:
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(SereneColors.arena(colorScheme), lineWidth: BorderWidth.emphasis)
            }
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        GratitudeSlotView(index: 0, entry: nil, state: .active, onTap: {})
        GratitudeSlotView(index: 1, entry: nil, state: .empty, onTap: {})
        GratitudeSlotView(index: 3, entry: nil, state: .extraLocked, onTap: {})
        GratitudeSlotView(index: 3, entry: nil, state: .extraUnlocked, onTap: {})
    }
    .padding()
}
