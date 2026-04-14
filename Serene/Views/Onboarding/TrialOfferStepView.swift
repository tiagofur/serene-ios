import SwiftUI

// Step 6/6: Oferta de trial Pro
// Per PRD: "Conversion sin presion. CTA secundario visible y sin culpa."
struct TrialOfferStepView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: OnboardingViewModel
    let onComplete: () -> Void

    @State private var showFeatures = false

    private let proFeatures = [
        ("sparkles", "Resúmenes semanales", "Tu coach analiza tu semana cada lunes"),
        ("chart.line.uptrend.xyaxis", "Patrones emocionales", "Descubre qué te hace sentir mejor"),
        ("clock.arrow.circlepath", "Historial completo", "Accede a todas tus gratitudes, siempre"),
        ("square.and.arrow.up", "Exportar en PDF", "Guarda tu diario de gratitud"),
    ]

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            // Badge
            HStack(spacing: Spacing.sm) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 14))
                    .foregroundColor(SereneColors.arena(colorScheme))
                Text("SERENE PRO")
                    .sereneLabel()
                    .foregroundColor(SereneColors.arena(colorScheme))
            }
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(
                Capsule()
                    .fill(SereneColors.arenaSoft(colorScheme))
            )

            VStack(spacing: Spacing.sm) {
                Text("Lleva tu gratitud al siguiente nivel")
                    .sereneDisplay(22)
                    .foregroundColor(SereneColors.textPrimary(colorScheme))
                    .multilineTextAlignment(.center)

                Text("14 días gratis. Sin tarjeta. Cancela cuando quieras.")
                    .sereneBody()
                    .foregroundColor(SereneColors.textSecondary(colorScheme))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Spacing.md)

            // Features list
            VStack(spacing: Spacing.md) {
                ForEach(Array(proFeatures.enumerated()), id: \.offset) { index, feature in
                    HStack(spacing: Spacing.md) {
                        Image(systemName: feature.0)
                            .font(.system(size: 18))
                            .foregroundColor(SereneColors.sage(colorScheme))
                            .frame(width: 36, height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: Radius.sm)
                                    .fill(SereneColors.sageSoft(colorScheme))
                            )

                        VStack(alignment: .leading, spacing: 2) {
                            Text(feature.1)
                                .sereneBody()
                                .foregroundColor(SereneColors.textPrimary(colorScheme))
                            Text(feature.2)
                                .sereneMicro()
                                .foregroundColor(SereneColors.textTertiary(colorScheme))
                        }

                        Spacer()
                    }
                    .opacity(showFeatures ? 1 : 0)
                    .offset(y: showFeatures ? 0 : 15)
                    .animation(
                        .easeOut(duration: 0.35).delay(Double(index) * 0.1),
                        value: showFeatures
                    )
                }
            }
            .padding(.horizontal, Spacing.lg)

            Spacer()

            // Price info
            VStack(spacing: Spacing.xs) {
                Text("Después del trial:")
                    .sereneMicro()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
                HStack(spacing: Spacing.sm) {
                    Text("$4.99/mes")
                        .sereneBody()
                        .foregroundColor(SereneColors.textPrimary(colorScheme))
                    Text("o")
                        .sereneMicro()
                        .foregroundColor(SereneColors.textTertiary(colorScheme))
                    VStack(spacing: 0) {
                        Text("$34.99/año")
                            .sereneBody()
                            .foregroundColor(SereneColors.sage(colorScheme))
                        Text("ahorra 42%")
                            .sereneMicro()
                            .foregroundColor(SereneColors.sage(colorScheme))
                    }
                }
            }

            // Trial CTA
            Button {
                // Start trial via StoreKit 2
                onComplete()
            } label: {
                Text("Empezar 14 días gratis")
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

            // Skip — per PRD: NEVER "Omitir" or "Skip"
            Button {
                onComplete()
            } label: {
                Text("Continuar con plan gratuito")
                    .sereneBody(14)
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
            }
            .padding(.bottom, Spacing.lg)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showFeatures = true
            }
        }
    }
}

#Preview {
    TrialOfferStepView(viewModel: OnboardingViewModel(), onComplete: {})
}
