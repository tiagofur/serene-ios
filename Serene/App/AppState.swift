import SwiftUI

@MainActor
final class AppState: ObservableObject {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @AppStorage("userName") var userName = ""
    @AppStorage("reminderHour") var reminderHour = 21
    @AppStorage("reminderMinute") var reminderMinute = 0

    @Published var currentStreak = 0
    @Published var todayGratitudes: [Gratitude] = []

    var todayCompleted: Int {
        todayGratitudes.count
    }

    var extrasUnlocked: Bool {
        todayCompleted >= 3
    }
}
