import SwiftUI
import SwiftData
import Combine

@MainActor
final class TodayViewModel: ObservableObject {
    // MARK: - Published State
    @Published var todayGratitudes: [GratitudeEntry] = []
    @Published var streakData: StreakData?
    @Published var isWritingSheetPresented = false
    @Published var selectedSlotIndex: Int = 0
    @Published var showCelebration = false
    @Published var extrasUnlocked = false
    @Published var isLoadingCoachResponse = false
    @Published var coachResponseText = ""

    // MARK: - Computed Properties
    var completedBaseCount: Int {
        todayGratitudes.filter { !$0.isExtra && $0.isCompleted }.count
    }

    var allBaseCompleted: Bool {
        completedBaseCount >= 3
    }

    var completedExtrasCount: Int {
        todayGratitudes.filter { $0.isExtra && $0.isCompleted }.count
    }

    var totalCompleted: Int {
        completedBaseCount + completedExtrasCount
    }

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Buenos días"
        case 12..<18: return "Buenas tardes"
        default: return "Buenas noches"
        }
    }

    var greetingEmoji: String {
        let month = Calendar.current.component(.month, from: Date())
        switch month {
        case 3...5: return "🌸"
        case 6...8: return "☀️"
        case 9...11: return "🍂"
        default: return "❄️"
        }
    }

    // MARK: - Slot prompts
    func promptForSlot(_ index: Int) -> String {
        switch index {
        case 0, 1, 2: return "Hoy agradezco..."
        case 3: return "¿Qué te sorprendió hoy?"
        case 4: return "¿A quién agradeces y no se lo has dicho?"
        default: return "Hoy agradezco..."
        }
    }

    // MARK: - Data Operations
    func loadTodayData(context: ModelContext) {
        todayGratitudes = GratitudeService.shared.todayGratitudes(context: context)

        let streakDescriptor = FetchDescriptor<StreakData>()
        if let existing = try? context.fetch(streakDescriptor).first {
            existing.checkMonthlyReset()
            streakData = existing
        } else {
            let newStreak = StreakData()
            context.insert(newStreak)
            streakData = newStreak
        }

        extrasUnlocked = allBaseCompleted
    }

    func openWritingSheet(for slotIndex: Int) {
        selectedSlotIndex = slotIndex
        isWritingSheetPresented = true
    }

    func saveGratitude(
        text: String,
        emoji: String,
        context: ModelContext,
        userName: String
    ) async {
        let isExtra = selectedSlotIndex >= 3

        isLoadingCoachResponse = true
        coachResponseText = ""

        // Save entry
        let entry = await GratitudeService.shared.saveGratitude(
            text: text,
            emoji: emoji,
            slotIndex: selectedSlotIndex,
            isExtra: isExtra,
            context: context
        )

        // Get AI coach response
        let previousTexts = todayGratitudes.map(\.text)
        let response = await AICoachService.shared.getCoachResponse(
            gratitudeText: text,
            emoji: emoji,
            userName: userName,
            previousGratitudes: previousTexts
        )
        entry.aiResponse = response
        coachResponseText = response
        isLoadingCoachResponse = false

        // Reload data
        loadTodayData(context: context)

        // Check if we just completed all 3 base gratitudes
        if completedBaseCount == 3 && !extrasUnlocked {
            // Update streak
            streakData?.recordEntry()

            // Show celebration after a brief delay
            try? await Task.sleep(nanoseconds: 500_000_000)
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                showCelebration = true
                extrasUnlocked = true
            }
        }
    }

    // MARK: - Week dots
    func weekDots() -> [WeekDotState] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: today)
        // Monday = start of week
        let mondayOffset = weekday == 1 ? -6 : -(weekday - 2)

        return (0..<7).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: mondayOffset + dayOffset, to: today)!
            let isToday = calendar.isDateInToday(date)
            let isFuture = date > today

            if isFuture {
                return .empty
            } else if isToday {
                return completedBaseCount >= 3 ? .done : .today
            } else {
                // Check if there are gratitudes for this day
                let hasEntries = todayGratitudes.contains { entry in
                    calendar.isDate(entry.createdAt, inSameDayAs: date)
                }
                // For past days, we'd need to query — simplified for now
                return hasEntries ? .done : .empty
            }
        }
    }
}

enum WeekDotState {
    case done   // Sage color
    case today  // Arena color
    case empty  // Transparent + border
}
