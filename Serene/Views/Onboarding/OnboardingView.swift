import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var currentStep = 0

    private let totalSteps = 6

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            VStack {
                // Progress dots
                HStack(spacing: Spacing.sm) {
                    ForEach(0..<totalSteps, id: \.self) { step in
                        Capsule()
                            .fill(step <= currentStep ? Color.sage : Color.borderDefault)
                            .frame(height: 3)
                    }
                }
                .padding(.horizontal, Spacing.md)
                .padding(.top, Spacing.md)

                // Content
                TabView(selection: $currentStep) {
                    WelcomeStep(viewModel: viewModel)
                        .tag(0)
                    ScienceStep()
                        .tag(1)
                    FirstGratitudeStep(viewModel: viewModel)
                        .tag(2)
                    CoachResponseStep(viewModel: viewModel)
                        .tag(3)
                    ReminderStep(viewModel: viewModel)
                        .tag(4)
                    TrialOfferStep()
                        .tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // Navigation
                Button {
                    advance()
                } label: {
                    Text(currentStep == totalSteps - 1 ? "Comenzar" : "Continuar")
                        .font(.jakarta(14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(15)
                        .background(Color.sage)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
                }
                .padding(.horizontal, Spacing.md)
                .padding(.bottom, Spacing.lg)
            }
        }
    }

    private func advance() {
        if currentStep < totalSteps - 1 {
            withAnimation {
                currentStep += 1
            }
        } else {
            appState.userName = viewModel.userName
            appState.reminderHour = viewModel.reminderHour
            appState.reminderMinute = viewModel.reminderMinute
            appState.hasCompletedOnboarding = true
        }
    }
}

// MARK: - Step 1: Welcome

struct WelcomeStep: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            Image(systemName: "leaf.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.sage)

            Text("Bienvenido a Serene")
                .font(.displayLarge)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)

            Text("Como te llamas?")
                .font(.body)
                .foregroundStyle(Color.textSecondary)

            TextField("Tu nombre", text: $viewModel.userName)
                .font(.body)
                .padding(14)
                .background(Color.surface)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.lg)
                        .stroke(Color.borderDefault, lineWidth: BorderWidth.emphasis)
                )
                .padding(.horizontal, Spacing.xl)

            Text("Como te sientes hoy?")
                .font(.body)
                .foregroundStyle(Color.textSecondary)
                .padding(.top, Spacing.sm)

            HStack(spacing: Spacing.md) {
                ForEach(GratitudeEmoji.allCases, id: \.self) { emoji in
                    Button {
                        viewModel.initialMood = emoji
                    } label: {
                        VStack(spacing: Spacing.xs) {
                            Text(emoji.symbol)
                                .font(.title)
                            Text(emoji.label)
                                .font(.micro)
                                .foregroundStyle(Color.textTertiary)
                        }
                        .padding(Spacing.sm)
                        .background(
                            viewModel.initialMood == emoji ? Color.sageSoft : Color.clear
                        )
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                    }
                }
            }

            Spacer()
        }
        .padding(Spacing.md)
    }
}

// MARK: - Step 2: Science

struct ScienceStep: View {
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            Image(systemName: "brain.head.profile")
                .font(.system(size: 44))
                .foregroundStyle(Color.sage)

            Text("La ciencia de la gratitud")
                .font(.display)
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: Spacing.md) {
                benefitRow(icon: "heart.fill", text: "Reduce la ansiedad hasta un 25%")
                benefitRow(icon: "moon.fill", text: "Mejora la calidad del sueno")
                benefitRow(icon: "figure.mind.and.body", text: "Aumenta la resiliencia emocional")
                benefitRow(icon: "person.2.fill", text: "Fortalece las relaciones personales")
            }
            .padding(Spacing.lg)

            Text("Basado en investigacion de Seligman y Emmons")
                .font(.label)
                .foregroundStyle(Color.textTertiary)

            Spacer()
        }
        .padding(Spacing.md)
    }

    private func benefitRow(icon: String, text: String) -> some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .foregroundStyle(Color.sage)
                .frame(width: 24)
            Text(text)
                .font(.body)
                .foregroundStyle(Color.textPrimary)
        }
    }
}

// MARK: - Step 3: First Gratitude

struct FirstGratitudeStep: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            Text("Tu primer momento")
                .font(.display)
                .foregroundStyle(Color.textPrimary)

            Text("Escribe algo por lo que estes agradecido ahora mismo. No tiene que ser grande.")
                .font(.body)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)

            ZStack(alignment: .topLeading) {
                if viewModel.firstGratitude.isEmpty {
                    Text("Hoy agradezco...")
                        .font(.body)
                        .foregroundStyle(Color.textTertiary)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                }
                TextEditor(text: $viewModel.firstGratitude)
                    .font(.body)
                    .foregroundStyle(Color.textPrimary)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 120)
            }
            .padding(14)
            .background(Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.lg)
                    .stroke(Color.sage, lineWidth: BorderWidth.emphasis)
            )
            .padding(.horizontal, Spacing.md)

            Spacer()
        }
        .padding(Spacing.md)
    }
}

// MARK: - Step 4: Coach Response (THE MOST IMPORTANT)

struct CoachResponseStep: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var displayedText = ""
    @State private var showAvatar = false

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            Text("Tu coach responde")
                .font(.display)
                .foregroundStyle(Color.textPrimary)

            // User's gratitude
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Tu escribiste:")
                    .font(.label)
                    .foregroundStyle(Color.textTertiary)
                Text(viewModel.firstGratitude.isEmpty ? "..." : viewModel.firstGratitude)
                    .font(.body)
                    .foregroundStyle(Color.textPrimary)
            }
            .padding(Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.surface)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))

            // Coach reply
            if showAvatar {
                CoachReplyBubble(text: displayedText.isEmpty ? "..." : displayedText)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            Spacer()
        }
        .padding(Spacing.md)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4).delay(0.5)) {
                showAvatar = true
            }
            viewModel.generateCoachResponse { response in
                animateText(response)
            }
        }
    }

    private func animateText(_ text: String) {
        displayedText = ""
        for (i, char) in text.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 + Double(i) * 0.028) {
                displayedText.append(char)
            }
        }
    }
}

// MARK: - Step 5: Reminder

struct ReminderStep: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            Image(systemName: "bell.badge.fill")
                .font(.system(size: 44))
                .foregroundStyle(Color.arena)

            Text("Tu ritual diario")
                .font(.display)
                .foregroundStyle(Color.textPrimary)

            Text("A que hora prefieres escribir tus gratitudes?")
                .font(.body)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)

            DatePicker(
                "Hora del recordatorio",
                selection: Binding(
                    get: {
                        Calendar.current.date(
                            from: DateComponents(hour: viewModel.reminderHour, minute: viewModel.reminderMinute)
                        ) ?? .now
                    },
                    set: { date in
                        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                        viewModel.reminderHour = components.hour ?? 21
                        viewModel.reminderMinute = components.minute ?? 0
                    }
                ),
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()

            Spacer()
        }
        .padding(Spacing.md)
    }
}

// MARK: - Step 6: Trial Offer

struct TrialOfferStep: View {
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            Image(systemName: "sparkles")
                .font(.system(size: 44))
                .foregroundStyle(Color.sage)

            Text("Prueba Serene Pro")
                .font(.display)
                .foregroundStyle(Color.textPrimary)

            Text("14 dias gratis. Sin tarjeta de credito.")
                .font(.body)
                .foregroundStyle(Color.textSecondary)

            VStack(alignment: .leading, spacing: Spacing.md) {
                proFeature(text: "Reflexiones extra desbloqueadas")
                proFeature(text: "Resumen semanal del coach")
                proFeature(text: "Patrones emocionales")
                proFeature(text: "Historial ilimitado")
                proFeature(text: "Exportar en PDF")
            }
            .padding(Spacing.lg)

            Text("$4.99/mes despues del trial")
                .font(.label)
                .foregroundStyle(Color.textTertiary)

            Button {
                // Skip trial — handled by parent advance()
            } label: {
                Text("Quizas despues")
                    .font(.jakarta(14))
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer()
        }
        .padding(Spacing.md)
    }

    private func proFeature(text: String) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color.sage)
            Text(text)
                .font(.body)
                .foregroundStyle(Color.textPrimary)
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
