import SwiftUI

struct CelebrationOverlay: View {
    let streakCount: Int
    let onDismiss: () -> Void

    @State private var showOverlay = false
    @State private var showRing = false
    @State private var showTitle = false
    @State private var showSubtitle = false
    @State private var streakPop = false
    @State private var showExtra1 = false
    @State private var showExtra2 = false

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(showOverlay ? 0.3 : 0)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: Spacing.lg) {
                // Ring with emoji
                ZStack {
                    Circle()
                        .fill(Color.sageSoft)
                        .frame(width: 64, height: 64)
                    Circle()
                        .stroke(Color.sage, lineWidth: 2)
                        .frame(width: 64, height: 64)
                    Text("✨")
                        .font(.system(size: 30))
                }
                .scaleEffect(showRing ? 1.0 : 0.4)
                .opacity(showRing ? 1 : 0)

                // Streak number
                Text("\(streakCount)")
                    .font(.jakarta(32, weight: .bold))
                    .foregroundStyle(Color.sage)
                    .scaleEffect(streakPop ? 1.0 : 1.25)

                // Title
                Text("Completaste tus 3 gratitudes")
                    .font(.serifDisplay(22))
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)
                    .offset(y: showTitle ? 0 : 8)
                    .opacity(showTitle ? 1 : 0)

                // Subtitle
                Text("Desbloqueaste 2 reflexiones extra")
                    .font(.jakarta(13))
                    .foregroundStyle(Color.textSecondary)
                    .offset(y: showSubtitle ? 0 : 8)
                    .opacity(showSubtitle ? 1 : 0)

                // Extra slots preview
                VStack(spacing: Spacing.sm) {
                    extraSlotPreview(
                        number: 1,
                        prompt: Gratitude.prompt(for: 0, isExtra: true),
                        isVisible: showExtra1
                    )
                    extraSlotPreview(
                        number: 2,
                        prompt: Gratitude.prompt(for: 1, isExtra: true),
                        isVisible: showExtra2
                    )
                }

                // Dismiss button
                Button(action: onDismiss) {
                    Text("Por hoy es suficiente")
                        .font(.jakarta(14))
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.top, Spacing.sm)
            }
            .padding(Spacing.xl)
            .background(Color.cardElevated)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.xl))
            .padding(.horizontal, Spacing.lg)
            .offset(y: showOverlay ? 0 : 60)
            .opacity(showOverlay ? 1 : 0)
        }
        .onAppear { runAnimationSequence() }
    }

    private func extraSlotPreview(number: Int, prompt: String, isVisible: Bool) -> some View {
        HStack(spacing: Spacing.sm) {
            Text("Extra \(number)")
                .font(.micro)
                .foregroundStyle(Color.arena)
                .padding(.horizontal, Spacing.sm)
                .padding(.vertical, Spacing.xs)
                .background(Color.arenaSoft)
                .clipShape(Capsule())

            Text(prompt)
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)

            Spacer()
        }
        .padding(Spacing.md)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.lg)
                .stroke(Color.arena, lineWidth: BorderWidth.emphasis)
        )
        .offset(y: isVisible ? 0 : 12)
        .opacity(isVisible ? 1 : 0)
    }

    private func runAnimationSequence() {
        withAnimation(.spring(duration: 0.4)) {
            showOverlay = true
        }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.15)) {
            showRing = true
        }
        withAnimation(.spring(duration: 0.4).delay(0.3)) {
            streakPop = true
        }
        withAnimation(.easeOut(duration: 0.4).delay(0.4)) {
            showTitle = true
        }
        withAnimation(.easeOut(duration: 0.4).delay(0.55)) {
            showSubtitle = true
        }
        withAnimation(.easeOut(duration: 0.35).delay(0.9)) {
            showExtra1 = true
        }
        withAnimation(.easeOut(duration: 0.35).delay(1.1)) {
            showExtra2 = true
        }
    }
}

#Preview {
    CelebrationOverlay(streakCount: 7) {}
}
