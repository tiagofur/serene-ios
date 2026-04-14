import SwiftUI

// Step 4/6: Respuesta del coach — THE MOST IMPORTANT SCREEN
// Per PRD: "LA PANTALLA MAS IMPORTANTE. El usuario siente la magia."
struct CoachResponseStepView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: OnboardingViewModel

    @State private var displayedText = ""
    @State private var showTitle = false
    @State private var showResponse = false
    @State private var showButton = false

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            // Coach avatar
            ZStack {
                Circle()
                    .fill(SereneColors.sageSoft(colorScheme))
                    .frame(width: 72, height: 72)
                Circle()
                    .stroke(SereneColors.sage(colorScheme), lineWidth: 2)
                    .frame(width: 72, height: 72)
                Image(systemName: "sparkle")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(SereneColors.sage(colorScheme))
            }

            // Title
            VStack(spacing: Spacing.sm) {
                Text("Tu coach ha leído tu gratitud")
                    .sereneDisplay(22)
                    .foregroundColor(SereneColors.textPrimary(colorScheme))
                    .multilineTextAlignment(.center)
                    .opacity(showTitle ? 1 : 0)
                    .offset(y: showTitle ? 0 : 10)
            }

            // User's gratitude
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Tu escribiste:")
                    .sereneLabel()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))

                Text(viewModel.firstGratitudeText)
                    .sereneBody()
                    .foregroundColor(SereneColors.textPrimary(colorScheme))
                    .padding(Spacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: Radius.md)
                            .fill(SereneColors.surface(colorScheme))
                    )
            }
            .padding(.horizontal, Spacing.lg)

            // Coach response
            if showResponse {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack(spacing: Spacing.sm) {
                        ZStack {
                            Circle()
                                .fill(SereneColors.sage(colorScheme))
                                .frame(width: 24, height: 24)
                            Image(systemName: "sparkle")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                        Text("Tu coach")
                            .sereneLabel()
                            .foregroundColor(SereneColors.sage(colorScheme))
                    }

                    Text(displayedText)
                        .sereneBody()
                        .foregroundColor(SereneColors.textPrimary(colorScheme))
                        .padding(Spacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: Radius.md)
                                .fill(SereneColors.cardElevated(colorScheme))
                                .overlay(
                                    RoundedRectangle(cornerRadius: Radius.md)
                                        .stroke(SereneColors.sage(colorScheme).opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                .padding(.horizontal, Spacing.lg)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            Spacer()

            // Continue button
            if showButton {
                Button {
                    viewModel.nextStep()
                } label: {
                    Text("Continuar")
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
                .padding(.bottom, Spacing.lg)
                .transition(.opacity)
            }
        }
        .onAppear {
            runEntryAnimation()
        }
    }

    private func runEntryAnimation() {
        // Show title
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.5)) {
                showTitle = true
            }
        }

        // Show response area
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeOut(duration: 0.4)) {
                showResponse = true
            }
            // Type out response character by character
            animateText(viewModel.coachResponse)
        }
    }

    private func animateText(_ fullText: String) {
        displayedText = ""
        var charIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.028, repeats: true) { timer in
            if charIndex < fullText.count {
                let index = fullText.index(fullText.startIndex, offsetBy: charIndex)
                displayedText += String(fullText[index])
                charIndex += 1
            } else {
                timer.invalidate()
                // Show continue button after typing completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showButton = true
                    }
                }
            }
        }
    }
}

#Preview {
    let vm = OnboardingViewModel()
    vm.firstGratitudeText = "Hoy agradezco el café de la mañana y la tranquilidad de un momento para mí."
    vm.coachResponse = "Qué bonito que notes eso. Tomarse un momento para uno mismo es un acto de cuidado profundo. El café no es solo una bebida — es tu ritual de presencia. 🌿"
    return CoachResponseStepView(viewModel: vm)
}
