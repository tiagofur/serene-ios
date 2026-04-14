import Foundation
import SwiftData

@Model
final class GratitudeEntry {
    var id: UUID
    var text: String
    var emoji: String
    var photoURL: String?
    var aiResponse: String?
    var sentimentScore: Double?
    var slotIndex: Int // 0-4 (0-2 base, 3-4 extras)
    var isExtra: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        text: String,
        emoji: String = "",
        photoURL: String? = nil,
        aiResponse: String? = nil,
        sentimentScore: Double? = nil,
        slotIndex: Int = 0,
        isExtra: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.text = text
        self.emoji = emoji
        self.photoURL = photoURL
        self.aiResponse = aiResponse
        self.sentimentScore = sentimentScore
        self.slotIndex = slotIndex
        self.isExtra = isExtra
        self.createdAt = createdAt
    }
}

// MARK: - Convenience
extension GratitudeEntry {
    var isCompleted: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    static var todayPredicate: Predicate<GratitudeEntry> {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        return #Predicate<GratitudeEntry> { entry in
            entry.createdAt >= startOfDay && entry.createdAt < endOfDay
        }
    }
}

// MARK: - Emoji Moods
enum GratitudeMood: String, CaseIterable, Identifiable {
    case happy = "😊"
    case grateful = "🙏"
    case calm = "😌"
    case loved = "❤️"
    case reflective = "🤔"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .happy: return "Feliz"
        case .grateful: return "Agradecido"
        case .calm: return "En calma"
        case .loved: return "Querido"
        case .reflective: return "Reflexivo"
        }
    }
}
