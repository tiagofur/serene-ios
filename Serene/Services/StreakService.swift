import Foundation

final class StreakService {
    static let shared = StreakService()

    private let calendar = Calendar.current

    /// Check if today's entry exists and update streak accordingly
    func updateStreak(_ streak: Streak, hasEntryToday: Bool) -> Streak {
        guard hasEntryToday else { return streak }

        let today = calendar.startOfDay(for: .now)

        // Already counted today
        if let lastDate = streak.lastEntryDate,
           calendar.isDate(lastDate, inSameDayAs: today) {
            return streak
        }

        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        if let lastDate = streak.lastEntryDate,
           calendar.isDate(lastDate, inSameDayAs: yesterday) {
            // Consecutive day
            streak.currentStreak += 1
        } else if streak.lastEntryDate == nil {
            // First entry ever
            streak.currentStreak = 1
        } else {
            // Streak broken
            streak.currentStreak = 1
        }

        streak.lastEntryDate = today
        streak.longestStreak = max(streak.longestStreak, streak.currentStreak)
        return streak
    }

    /// Rescue a broken streak (max 1 per month)
    func rescueStreak(_ streak: Streak) -> Bool {
        guard streak.canRescue else { return false }

        let yesterday = calendar.date(byAdding: .day, value: -1, to: .now)!

        // Restore streak as if yesterday was completed
        streak.currentStreak += 1
        streak.lastEntryDate = calendar.startOfDay(for: yesterday)
        streak.rescuesUsed += 1
        return true
    }
}
