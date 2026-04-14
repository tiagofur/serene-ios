import SwiftUI

struct OnboardingView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = OnboardingViewModel()

    let onComplete: () -> Void

    var body: some View {
        ZStack {
            SereneColors.background(colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar
                progressBar
                    .padding(.horizontal, Spacing.lg)
                    .padding(.top, Spacing.md)

                // Step content
                TabView(selection: $viewModel.currentStep) {
                    WelcomeStepView(viewModel: viewModel)
                        .tag(0)
                    ScienceStepView(viewModel: viewModel)
                        .tag(1)
                    FirstGratitudeStepView(viewModel: viewModel)
                        .tag(2)
                    CoachResponseStepView(viewModel: viewModel)
                        .tag(3)
                    ReminderStepView(viewModel: viewModel)
                        .tag(4)
                    TrialOfferStepView(
                        viewModel: viewModel,
                        onComplete: {
                            appState.updateUserName(viewModel.userName)
                            appState.updateReminderTime(viewModel.selectedReminderTime)
                            onComplete()
                        }
                    )
                    .tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.35), value: viewModel.currentStep)
            }
        }
    }

    private var progressBar: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(SereneColors.surface(colorScheme))
                    .frame(height: 3)

                RoundedRectangle(cornerRadius: 2)
                    .fill(SereneColors.sage(colorScheme))
                    .frame(
                        width: proxy.size.width * viewModel.progress,
                        height: 3
                    )
                    .animation(.easeInOut(duration: 0.3), value: viewModel.progress)
            }
        }
        .frame(height: 3)
    }
}

#Preview {
    OnboardingView(onComplete: {})
        .environmentObject(AppState())
}
