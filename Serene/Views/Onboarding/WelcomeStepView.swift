import SwiftUI

// Step 1/6: Bienvenida + estado emocional
struct WelcomeStepView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: OnboardingViewModel

    private let moods = [
        ("😊", "Bien"),
        ("😐", "Normal"),
        ("😔", "Bajo"),
        ("😤", "Estresado"),
        ("😴", "Agotado"),
    ]

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            // Icon
            Text("🌿")
                .font(.system(size: 56))

            // Title
            VStack(spacing: Spacing.sm) {
                Text("Bienvenido a Serene")
                    .sereneDisplay(28)
                    .foregroundColor(SereneColors.textPrimary(colorScheme))

                Text("Tu espacio personal de gratitud y bienestar")
                    .sereneBody()
                    .foregroundColor(SereneColors.textSecondary(colorScheme))
                    .multilineTextAlignment(.center)
            }

            // Name field
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("¿Cómo te llamas?")
                    .sereneLabel()
                    .foregroundColor(SereneColors.textSecondary(colorScheme))

                TextField("Tu nombre", text: $viewModel.userName)
                    .sereneBody()
                    .foregroundColor(SereneColors.textPrimary(colorScheme))
                    .padding(.horizontal, Spacing.md)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: Radius.md)
                            .stroke(SereneColors.borderDefault(colorScheme), lineWidth: BorderWidth.emphasis)
                    )
            }
            .padding(.horizontal, Spacing.lg)

            // Mood selector
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("¿Cómo te sientes hoy?")
                    .sereneLabel()
                    .foregroundColor(SereneColors.textSecondary(colorScheme))

                HStack(spacing: Spacing.md) {
                    ForEach(moods, id: \.0) { emoji, label in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                viewModel.selectedMood = emoji
                            }
                        } label: {
                            VStack(spacing: 4) {
                                Text(emoji)
                                    .font(.system(size: 28))
                                Text(label)
                                    .sereneMicro()
                                    .foregroundColor(SereneColors.textTertiary(colorScheme))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Spacing.sm)
                            .background(
                                RoundedRectangle(cornerRadius: Radius.md)
                                    .fill(viewModel.selectedMood == emoji ?
                                          SereneColors.sageSoft(colorScheme) : Color.clear)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: Radius.md)
                                    .stroke(
                                        viewModel.selectedMood == emoji ?
                                        SereneColors.sage(colorScheme) : Color.clear,
                                        lineWidth: BorderWidth.emphasis
                                    )
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, Spacing.lg)

            Spacer()

            // Continue button
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
                            .fill(!viewModel.userName.isEmpty ?
                                  SereneColors.sage(colorScheme) : SereneColors.borderDefault(colorScheme))
                    )
            }
            .disabled(viewModel.userName.isEmpty)
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.lg)
        }
    }
}

#Preview {
    WelcomeStepView(viewModel: OnboardingViewModel())
}
