import SwiftUI

struct CelebrationOverlayView: View {
    @Environment(\.colorScheme) private var colorScheme

    let streakCount: Int
    let onDismiss: () -> Void
    let onOpenExtra: (Int) -> Void

    // Animation states
    @State private var showParticles = false
    @State private var showOverlay = false
    @State private var showRing = false
    @State private var showTitle = false
    @State private var showSubtitle = false
    @State private var streakPopped = false
    @State private var showExtra1 = false
    @State private var showExtra2 = false

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            // Particles
            if showParticles {
                FloatingParticlesView()
            }

            // Main overlay card
            VStack(spacing: Spacing.lg) {
                // Ring with emoji
                ZStack {
                    Circle()
                        .fill(SereneColors.sageSoft(colorScheme))
                        .frame(width: 64, height: 64)
                    Circle()
                        .stroke(SereneColors.sage(colorScheme), lineWidth: 2)
                        .frame(width: 64, height: 64)
                    Text("✨")
                        .font(.system(size: 30))
                }
                .scaleEffect(showRing ? 1.0 : 0.4)
                .opacity(showRing ? 1.0 : 0)

                // Streak count
                Text("\(streakCount)")
                    .sereneDisplay(32)
                    .foregroundColor(SereneColors.sage(colorScheme))
                    .scaleEffect(streakPopped ? 1.25 : 1.0)

                // Title
                Text("¡Día completo!")
                    .sereneDisplay(22)
                    .foregroundColor(SereneColors.textPrimary(colorScheme))
                    .offset(y: showTitle ? 0 : 8)
                    .opacity(showTitle ? 1 : 0)

                // Subtitle
                Text("Has completado tus 3 gratitudes. ¿Quieres ir más profundo?")
                    .sereneBody(13)
                    .foregroundColor(SereneColors.textSecondary(colorScheme))
                    .multilineTextAlignment(.center)
                    .offset(y: showSubtitle ? 0 : 8)
                    .opacity(showSubtitle ? 1 : 0)

                Divider()
                    .padding(.horizontal, Spacing.lg)

                // Extra slots
                VStack(spacing: Spacing.md) {
                    extraSlotButton(
                        index: 0,
                        prompt: "¿Qué te sorprendió hoy?",
                        isVisible: showExtra1
                    )

                    extraSlotButton(
                        index: 1,
                        prompt: "¿A quién agradeces y no se lo has dicho?",
                        isVisible: showExtra2
                    )
                }
                .padding(.horizontal, Spacing.md)

                // Dismiss button
                Button(action: onDismiss) {
                    Text("Por hoy es suficiente")
                        .sereneBody(14)
                        .foregroundColor(SereneColors.textTertiary(colorScheme))
                }
                .padding(.top, Spacing.sm)
            }
            .padding(Spacing.lg)
            .padding(.vertical, Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Radius.xl)
                    .fill(SereneColors.cardElevated(colorScheme))
            )
            .padding(.horizontal, Spacing.lg)
            .offset(y: showOverlay ? 0 : 60)
            .opacity(showOverlay ? 1 : 0)
        }
        .onAppear(perform: runAnimationSequence)
    }

    // MARK: - Extra Slot Button
    @ViewBuilder
    private func extraSlotButton(index: Int, prompt: String, isVisible: Bool) -> some View {
        Button {
            onOpenExtra(index)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: Spacing.xs) {
                        Text("Extra \(index + 1)")
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
                    Text(prompt)
                        .sereneBody(13)
                        .foregroundColor(SereneColors.textSecondary(colorScheme))
                        .lineLimit(1)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(SereneColors.arena(colorScheme))
            }
            .padding(Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .fill(SereneColors.surface(colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.lg)
                            .stroke(SereneColors.arena(colorScheme), lineWidth: BorderWidth.emphasis)
                    )
            )
        }
        .buttonStyle(.plain)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 20)
    }

    // MARK: - Animation Sequence (per PRD spec)
    private func runAnimationSequence() {
        // t=0ms: Particles
        withAnimation(.easeOut(duration: 0.5)) {
            showParticles = true
        }

        // t=80ms: Overlay slides up
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showOverlay = true
            }
        }

        // t=150ms: Ring pop-in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                showRing = true
            }
        }

        // t=300ms: Streak pop
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                streakPopped = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    streakPopped = false
                }
            }
        }

        // t=400ms: Title
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeOut(duration: 0.4)) {
                showTitle = true
            }
        }

        // t=550ms: Subtitle
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            withAnimation(.easeOut(duration: 0.4)) {
                showSubtitle = true
            }
        }

        // t=900ms: Extra 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.easeOut(duration: 0.35)) {
                showExtra1 = true
            }
        }

        // t=1100ms: Extra 2
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            withAnimation(.easeOut(duration: 0.35)) {
                showExtra2 = true
            }
        }
    }
}

// MARK: - Floating Particles
struct FloatingParticlesView: View {
    let particleCount = 18

    var body: some View {
        ZStack {
            ForEach(0..<particleCount, id: \.self) { index in
                FloatingParticle(index: index)
            }
        }
    }
}

struct FloatingParticle: View {
    let index: Int
    @State private var yOffset: CGFloat = 0
    @State private var opacity: Double = 1

    private let colors: [Color] = [
        Color(hex: "5A7A6B"),  // Sage
        Color(hex: "C4956A"),  // Arena
        Color(hex: "C0706E"),  // Rosa
        Color(hex: "E0EDE7"),  // Sage soft
        Color(hex: "F5EAD8"),  // Arena soft
    ]

    private var randomX: CGFloat {
        CGFloat.random(in: -150...150)
    }

    private var duration: Double {
        Double.random(in: 0.9...1.7)
    }

    var body: some View {
        Circle()
            .fill(colors[index % colors.count])
            .frame(width: CGFloat.random(in: 4...8), height: CGFloat.random(in: 4...8))
            .offset(x: randomX, y: yOffset)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: duration)) {
                    yOffset = -CGFloat.random(in: 100...300)
                    opacity = 0
                }
            }
    }
}

#Preview {
    CelebrationOverlayView(
        streakCount: 5,
        onDismiss: {},
        onOpenExtra: { _ in }
    )
}
