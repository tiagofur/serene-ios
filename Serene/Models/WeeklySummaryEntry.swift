import Foundation
import SwiftData

@Model
final class WeeklySummaryEntry {
    var id: UUID
    var weekStart: Date
    var narrative: String
    var topTopics: [String]
    var sentimentTrend: String
    var dominantEmoji: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        weekStart: Date = Date(),
        narrative: String = "",
        topTopics: [String] = [],
        sentimentTrend: String = "neutral",
        dominantEmoji: String = "😊",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.weekStart = weekStart
        self.narrative = narrative
        self.topTopics = topTopics
        self.sentimentTrend = sentimentTrend
        self.dominantEmoji = dominantEmoji
        self.createdAt = createdAt
    }
}
