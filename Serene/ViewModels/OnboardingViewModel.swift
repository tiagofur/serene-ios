import SwiftUI
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var currentStep = 0
    @Published var userName = ""
    @Published var selectedMood: String = ""
    @Published var firstGratitudeText = ""
    @Published var coachResponse = ""
    @Published var isLoadingCoach = false
    @Published var selectedReminderTime = Calendar.current.date(from: DateComponents(hour: 21, minute: 0)) ?? Date()
    @Published var notificationsEnabled = false

    let totalSteps = 6

    var progress: Double {
        Double(currentStep + 1) / Double(totalSteps)
    }

    func nextStep() {
        guard currentStep < totalSteps - 1 else { return }
        withAnimation(.easeInOut(duration: 0.35)) {
            currentStep += 1
        }
    }

    func previousStep() {
        guard currentStep > 0 else { return }
        withAnimation(.easeInOut(duration: 0.35)) {
            currentStep -= 1
        }
    }

    func submitFirstGratitude() async {
        guard !firstGratitudeText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isLoadingCoach = true

        let response = await AICoachService.shared.getCoachResponse(
            gratitudeText: firstGratitudeText,
            emoji: selectedMood,
            userName: userName
        )
        coachResponse = response
        isLoadingCoach = false

        // Auto-advance to coach response step
        nextStep()
    }

    func requestNotifications() async {
        notificationsEnabled = await NotificationService.shared.requestPermission()
        if notificationsEnabled {
            NotificationService.shared.scheduleDailyReminder(
                at: selectedReminderTime,
                userName: userName
            )
        }
    }
}
