import Foundation
import SwiftData

@Model
final class Streak {
    var currentStreak: Int
    var longestStreak: Int
    var lastEntryDate: Date?
    var rescuesUsed: Int

    init(
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        lastEntryDate: Date? = nil,
        rescuesUsed: Int = 0
    ) {
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastEntryDate = lastEntryDate
        self.rescuesUsed = rescuesUsed
    }

    /// Maximum rescues allowed per month
    static let maxRescuesPerMonth = 1

    var canRescue: Bool {
        rescuesUsed < Self.maxRescuesPerMonth
    }
}
