import Foundation

struct WeeklySummary: Codable, Identifiable {
    let id: UUID
    let weekStart: Date
    let narrative: String
    let topTopics: [String]
    let sentimentTrend: String
    let createdAt: Date
}
