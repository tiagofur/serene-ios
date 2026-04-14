import SwiftUI

// MARK: - Streak Rescue Sheet
// Per PRD: "1 vez al mes el usuario puede recuperar una racha perdida. Reduce frustracion"

struct StreakRescueSheet: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss

    let previousStreak: Int
    let canRescue: Bool
    let onRescue: () -> Void

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Capsule()
                .fill(SereneColors.borderDefault(colorScheme))
                .frame(width: 36, height: 4)
                .padding(.top, Spacing.sm)

            ZStack {
                Circle()
                    .fill(SereneColors.rosaSoft(colorScheme))
                    .frame(width: 64, height: 64)
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 36))
                    .foregroundColor(SereneColors.rosa(colorScheme))
            }
            .padding(.top, Spacing.md)

            VStack(spacing: Spacing.sm) {
                Text("Recupera tu racha")
                    .sereneDisplay(22)
                    .foregroundColor(SereneColors.textPrimary(colorScheme))

                Text(canRescue
                    ? "Los hábitos no se rompen por un día. Puedes rescatar tu racha de \(previousStreak) días — una vez al mes."
                    : "Ya usaste tu rescate este mes. Tranquilo: empezar de nuevo también es valioso. Estaremos aquí mañana.")
                    .sereneBody()
                    .foregroundColor(SereneColors.textSecondary(colorScheme))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.md)
            }

            if canRescue {
                Button {
                    onRescue()
                    dismiss()
                } label: {
                    Text("Rescatar mi racha")
                        .sereneBody(14)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: Radius.lg)
                                .fill(SereneColors.sage(colorScheme))
                        )
                }
                .padding(.horizontal, Spacing.lg)
            }

            Button {
                dismiss()
            } label: {
                Text(canRescue ? "Mejor empiezo de nuevo" : "Entendido")
                    .sereneBody(14)
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
            }
            .padding(.bottom, Spacing.lg)
        }
        .padding(.horizontal, Spacing.md)
        .background(SereneColors.background(colorScheme))
    }
}

#Preview {
    StreakRescueSheet(previousStreak: 12, canRescue: true, onRescue: {})
}
