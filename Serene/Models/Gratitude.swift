import Foundation
import SwiftData

@Model
final class Gratitude {
    @Attribute(.unique) var id: UUID
    var text: String
    var emoji: GratitudeEmoji
    var photoURL: String?
    var aiResponse: String?
    var sentimentScore: Double?
    var slotIndex: Int
    var isExtra: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        text: String,
        emoji: GratitudeEmoji = .neutral,
        photoURL: String? = nil,
        aiResponse: String? = nil,
        sentimentScore: Double? = nil,
        slotIndex: Int,
        isExtra: Bool = false,
        createdAt: Date = .now
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

// MARK: - Helpers

extension Gratitude {
    static let baseSlotCount = 3
    static let extraSlotCount = 2
    static let totalSlotCount = baseSlotCount + extraSlotCount

    var isBase: Bool { !isExtra }

    static func prompt(for slotIndex: Int, isExtra: Bool) -> String {
        if isExtra {
            return slotIndex == 0
                ? "Que te sorprendio hoy?"
                : "A quien agradeces y no se lo has dicho?"
        }
        return "Hoy agradezco..."
    }
}
