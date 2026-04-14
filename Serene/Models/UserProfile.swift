import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var name: String
    var email: String
    var locale: String
    var tier: String // "free" or "pro"
    var trialEndsAt: Date?
    var reminderTime: Date?
    var createdAt: Date

    init(
        id: UUID = UUID(),
        name: String = "",
        email: String = "",
        locale: String = "es",
        tier: String = "free",
        trialEndsAt: Date? = nil,
        reminderTime: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.locale = locale
        self.tier = tier
        self.trialEndsAt = trialEndsAt
        self.reminderTime = reminderTime
        self.createdAt = createdAt
    }

    var isPro: Bool {
        if tier == "pro" { return true }
        if let trialEnd = trialEndsAt, trialEnd > Date() { return true }
        return false
    }

    var isTrialActive: Bool {
        guard let trialEnd = trialEndsAt else { return false }
        return trialEnd > Date()
    }
}
