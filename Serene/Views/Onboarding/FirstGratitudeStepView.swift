import SwiftUI

// Step 3/6: Primera gratitud (ahora)
struct FirstGratitudeStepView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: OnboardingViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            VStack(spacing: Spacing.sm) {
                Text("Tu primera gratitud")
                    .sereneDisplay(24)
                    .foregroundColor(SereneColors.textPrimary(colorScheme))

                Text("No tiene que ser algo grande. Lo más pequeño es muchas veces lo más poderoso.")
                    .sereneBody()
                    .foregroundColor(SereneColors.textSecondary(colorScheme))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.md)
            }

            // Emoji selector
            HStack(spacing: Spacing.md) {
                ForEach(GratitudeMood.allCases) { mood in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.selectedMood = mood.rawValue
                        }
                    } label: {
                        Text(mood.rawValue)
                            .font(.system(size: 24))
                            .frame(width: 44, height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: Radius.md)
                                    .fill(viewModel.selectedMood == mood.rawValue ?
                                          SereneColors.sageSoft(colorScheme) : Color.clear)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: Radius.md)
                                    .stroke(
                                        viewModel.selectedMood == mood.rawValue ?
                                        SereneColors.sage(colorScheme) : SereneColors.borderDefault(colorScheme),
                                        lineWidth: viewModel.selectedMood == mood.rawValue ?
                                        BorderWidth.emphasis : BorderWidth.default
                                    )
                            )
                    }
                }
            }
            .padding(.horizontal, Spacing.lg)

            // Text editor
            TextEditor(text: $viewModel.firstGratitudeText)
                .sereneBody()
                .foregroundColor(SereneColors.textPrimary(colorScheme))
                .scrollContentBackground(.hidden)
                .frame(minHeight: 120)
                .padding(.horizontal, 14)
                .padding(.vertical, Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: Radius.lg)
                        .fill(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: Radius.lg)
                                .stroke(
                                    isFocused ? SereneColors.sage(colorScheme) : SereneColors.borderDefault(colorScheme),
                                    lineWidth: BorderWidth.emphasis
                                )
                        )
                )
                .focused($isFocused)
                .overlay(alignment: .topLeading) {
                    if viewModel.firstGratitudeText.isEmpty {
                        Text("Hoy agradezco...")
                            .sereneBody()
                            .foregroundColor(SereneColors.textTertiary(colorScheme))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 24)
                            .allowsHitTesting(false)
                    }
                }
                .padding(.horizontal, Spacing.lg)

            Spacer()

            // Submit button
            Button {
                Task {
                    await viewModel.submitFirstGratitude()
                }
            } label: {
                HStack(spacing: Spacing.sm) {
                    if viewModel.isLoadingCoach {
                        ProgressView()
                            .tint(.white)
                    }
                    Text(viewModel.isLoadingCoach ? "Tu coach está pensando..." : "Guardar mi gratitud")
                        .sereneBody(14)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: Radius.lg)
                        .fill(canSubmit ?
                              SereneColors.sage(colorScheme) : SereneColors.borderDefault(colorScheme))
                )
            }
            .disabled(!canSubmit)
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, Spacing.lg)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
    }

    private var canSubmit: Bool {
        !viewModel.firstGratitudeText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !viewModel.isLoadingCoach
    }
}

#Preview {
    FirstGratitudeStepView(viewModel: OnboardingViewModel())
}
