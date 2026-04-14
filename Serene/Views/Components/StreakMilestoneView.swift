import SwiftUI

// MARK: - Streak Milestone Celebration
// Shown on 7, 30, 100 day milestones. Per PRD: "no exagerada — no confetti explosion"

struct StreakMilestoneView: View {
    @Environment(\.colorScheme) private var colorScheme

    let milestone: Int
    let onDismiss: () -> Void

    @State private var showIcon = false
    @State private var showTitle = false
    @State private var showSubtitle = false
    @State private var showButton = false

    private var config: (emoji: String, title: String, subtitle: String) {
        switch milestone {
        case 7:
            return ("🌱", "Una semana",
                    "7 días seguidos. Algo está tomando raíz — y eso no es poca cosa.")
        case 30:
            return ("🌳", "Un mes completo",
                    "30 días contigo mismo. Esto ya no es una app: es tu hábito.")
        case 100:
            return ("✨", "100 días",
                    "Has construido algo raro y valioso. Gracias por confiar.")
        default:
            return ("🔥", "\(milestone) días",
                    "Sigue cuidándote así.")
        }
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            VStack(spacing: Spacing.lg) {
                Text(config.emoji)
                    .font(.system(size: 72))
                    .scaleEffect(showIcon ? 1.0 : 0.3)
                    .opacity(showIcon ? 1.0 : 0)

                VStack(spacing: Spacing.sm) {
                    Text(config.title)
                        .sereneDisplay(26)
                        .foregroundColor(SereneColors.textPrimary(colorScheme))
                        .offset(y: showTitle ? 0 : 8)
                        .opacity(showTitle ? 1 : 0)

                    Text(config.subtitle)
                        .sereneBody()
                        .foregroundColor(SereneColors.textSecondary(colorScheme))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.md)
                        .offset(y: showSubtitle ? 0 : 8)
                        .opacity(showSubtitle ? 1 : 0)
                }

                if showButton {
                    Button(action: onDismiss) {
                        Text("Gracias")
                            .sereneBody(14)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: Radius.lg)
                                    .fill(SereneColors.sage(colorScheme))
                            )
                    }
                    .padding(.horizontal, Spacing.md)
                    .transition(.opacity)
                }
            }
            .padding(Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: Radius.xl)
                    .fill(SereneColors.cardElevated(colorScheme))
            )
            .padding(.horizontal, Spacing.lg)
        }
        .onAppear(perform: animate)
    }

    private func animate() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.65)) {
            showIcon = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.4)) { showTitle = true }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 0.4)) { showSubtitle = true }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.easeOut(duration: 0.3)) { showButton = true }
        }
    }
}

#Preview {
    StreakMilestoneView(milestone: 7, onDismiss: {})
}
