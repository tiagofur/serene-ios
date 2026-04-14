import SwiftUI
import SwiftData
import Combine

@MainActor
final class TodayViewModel: ObservableObject {
    // MARK: - Published State
    @Published var todayGratitudes: [GratitudeEntry] = []
    @Published var pastWeekGratitudes: [GratitudeEntry] = []
    @Published var streakData: StreakData?
    @Published var isWritingSheetPresented = false
    @Published var selectedSlotIndex: Int = 0
    @Published var showCelebration = false
    @Published var extrasUnlocked = false
    @Published var isLoadingCoachResponse = false
    @Published var coachResponseText = ""
    @Published var showMilestone = false
    @Published var activeMilestone: Int = 0
    @Published var showRescueSheet = false

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

        // Past 7 days for accurate week dots
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        pastWeekGratitudes = GratitudeService.shared.gratitudes(
            from: weekAgo,
            to: Date(),
            context: context
        )

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

    // MARK: - Streak actions

    func shouldOfferRescue() -> Bool {
        guard let streak = streakData,
              let last = streak.lastEntryDate else { return false }
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let dayBeforeYesterday = Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
        // Offer rescue if last entry was 2 days ago (missed yesterday) and streak was meaningful
        return last < yesterday.startOfDay && last >= dayBeforeYesterday.startOfDay
            && streak.currentStreak >= 3 && streak.canRescue
    }

    func performRescue(context: ModelContext, userName: String) {
        guard let streak = streakData else { return }
        _ = streak.useRescue()
        try? context.save()
        // Cancel any pending streak protection notification
        SmartNotificationService.shared.cancelStreakProtection()
        loadTodayData(context: context)
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
            try? context.save()

            let streakAfter = streakData?.currentStreak ?? 0

            // Cancel streak protection (user has written today)
            SmartNotificationService.shared.cancelStreakProtection()

            // Check for milestone
            let milestone = milestoneForStreak(streakAfter)

            // Show celebration after a brief delay
            try? await Task.sleep(nanoseconds: 500_000_000)
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                showCelebration = true
                extrasUnlocked = true
            }

            // Queue milestone celebration after main celebration
            if let milestone {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                activeMilestone = milestone
                withAnimation(.easeInOut(duration: 0.4)) {
                    showMilestone = true
                }
                SmartNotificationService.shared.sendMilestoneNotification(
                    streak: milestone,
                    userName: userName
                )
            }

            // Schedule streak protection for tomorrow night if streak is meaningful
            if streakAfter >= 3 {
                SmartNotificationService.shared.scheduleStreakProtection(
                    userName: userName,
                    currentStreak: streakAfter
                )
            }

            // Refresh smart nudge based on usage patterns
            SmartNotificationService.shared.scheduleSmartNudge(
                userName: userName,
                context: context
            )
        }
    }

    private func milestoneForStreak(_ streak: Int) -> Int? {
        switch streak {
        case 7, 30, 100: return streak
        default: return nil
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
                let hasEntries = pastWeekGratitudes.contains { entry in
                    calendar.isDate(entry.createdAt, inSameDayAs: date)
                }
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
