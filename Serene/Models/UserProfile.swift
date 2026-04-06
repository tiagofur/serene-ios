import Foundation

struct UserProfile: Codable {
    let id: UUID
    var name: String
    var email: String
    var locale: String
    var tier: SubscriptionTier
    var trialEndsAt: Date?
    var reminderTime: DateComponents?
}

enum SubscriptionTier: String, Codable {
    case free
    case pro

    var isPro: Bool { self == .pro }
}
