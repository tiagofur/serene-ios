import SwiftUI

// Step 2/6: La ciencia de la gratitud
struct ScienceStepView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: OnboardingViewModel

    @State private var showItems = false

    private let benefits = [
        ("brain", "Reduce la ansiedad hasta un 23%", "Investigación de UC Davis"),
        ("heart.fill", "Mejora la calidad de sueño", "Estudio de Emmons & McCullough"),
        ("figure.mind.and.body", "Fortalece relaciones personales", "Psicología positiva de Seligman"),
    ]

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            VStack(spacing: Spacing.md) {
                Text("La ciencia detrás de la gratitud")
                    .sereneDisplay(24)
                    .foregroundColor(SereneColors.textPrimary(colorScheme))
                    .multilineTextAlignment(.center)

                Text("No es solo una moda. Décadas de investigación respaldan lo que estás a punto de experimentar.")
                    .sereneBody()
                    .foregroundColor(SereneColors.textSecondary(colorScheme))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.lg)
            }

            VStack(spacing: Spacing.md) {
                ForEach(Array(benefits.enumerated()), id: \.offset) { index, benefit in
                    HStack(spacing: Spacing.md) {
                        Image(systemName: benefit.0)
                            .font(.system(size: 20))
                            .foregroundColor(SereneColors.sage(colorScheme))
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(SereneColors.sageSoft(colorScheme))
                            )

                        VStack(alignment: .leading, spacing: 2) {
                            Text(benefit.1)
                                .sereneBody()
                                .foregroundColor(SereneColors.textPrimary(colorScheme))
                            Text(benefit.2)
                                .sereneMicro()
                                .foregroundColor(SereneColors.textTertiary(colorScheme))
                        }

                        Spacer()
                    }
                    .padding(Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: Radius.md)
                            .fill(SereneColors.surface(colorScheme))
                    )
                    .opacity(showItems ? 1 : 0)
                    .offset(y: showItems ? 0 : 20)
                    .animation(
                        .easeOut(duration: 0.4).delay(Double(index) * 0.15),
                        value: showItems
                    )
                }
            }
            .padding(.horizontal, Spacing.lg)

            Spacer()

            // Mechanic preview
            VStack(spacing: Spacing.sm) {
                Text("Tu ritual diario")
                    .sereneLabel()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))

                HStack(spacing: Spacing.sm) {
                    ForEach(0..<3, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 6)
                            .fill(SereneColors.sage(colorScheme))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Text("✓")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                            )
                    }
                    Text("+")
                        .foregroundColor(SereneColors.textTertiary(colorScheme))
                    ForEach(0..<2, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 6)
                            .fill(SereneColors.arena(colorScheme))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Text("★")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                            )
                    }
                }
                Text("3 gratitudes base + 2 extras de recompensa")
                    .sereneMicro()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
            }

            Button {
                viewModel.nextStep()
            } label: {
                Text("Empezar mi primer momento")
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
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showItems = true
            }
        }
    }
}

#Preview {
    ScienceStepView(viewModel: OnboardingViewModel())
}
