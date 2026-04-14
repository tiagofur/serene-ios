import Foundation
import SwiftData

@Model
final class StreakData {
    var id: UUID
    var currentStreak: Int
    var longestStreak: Int
    var lastEntryDate: Date?
    var rescuesUsedThisMonth: Int
    var lastRescueDate: Date?

    init(
        id: UUID = UUID(),
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        lastEntryDate: Date? = nil,
        rescuesUsedThisMonth: Int = 0,
        lastRescueDate: Date? = nil
    ) {
        self.id = id
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastEntryDate = lastEntryDate
        self.rescuesUsedThisMonth = rescuesUsedThisMonth
        self.lastRescueDate = lastRescueDate
    }

    var canRescue: Bool {
        rescuesUsedThisMonth < 1
    }

    func recordEntry() {
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!

        if let lastDate = lastEntryDate {
            let lastDay = Calendar.current.startOfDay(for: lastDate)
            if lastDay == today {
                return // Already recorded today
            } else if lastDay == yesterday {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }

        lastEntryDate = Date()
        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }
    }

    func useRescue() -> Bool {
        guard canRescue else { return false }
        rescuesUsedThisMonth += 1
        lastRescueDate = Date()
        // Restore streak as if yesterday was completed
        if currentStreak == 0 {
            currentStreak = 1
        }
        lastEntryDate = Date()
        return true
    }

    /// Resets monthly rescue counter if we're in a new month
    func checkMonthlyReset() {
        guard let lastRescue = lastRescueDate else { return }
        let calendar = Calendar.current
        if !calendar.isDate(lastRescue, equalTo: Date(), toGranularity: .month) {
            rescuesUsedThisMonth = 0
        }
    }
}
