import SwiftUI

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var userName = ""
    @Published var initialMood: GratitudeEmoji = .neutral
    @Published var firstGratitude = ""
    @Published var reminderHour = 21
    @Published var reminderMinute = 0

    private let coachService = AICoachService()

    func generateCoachResponse(completion: @escaping (String) -> Void) {
        guard !firstGratitude.isEmpty else {
            completion("Gracias por compartir eso conmigo. Cada momento de gratitud es un paso hacia una vida mas plena.")
            return
        }

        coachService.generateResponse(for: firstGratitude, emoji: initialMood) { response in
            completion(response)
        }
    }
}
