import Foundation
import SwiftData

// MARK: - Weekly Summary Service
// Generates narrative summaries per the PRD: "Esta semana, Tiago, tu mente
// estuvo en dos lugares: tu familia y tu trabajo creativo."

final class WeeklySummaryService {
    static let shared = WeeklySummaryService()
    private init() {}

    // MARK: - Public API

    /// Check if a summary should be generated for the current week
    func shouldGenerateSummary(context: ModelContext) -> Bool {
        let weekStart = Date().startOfWeek
        let descriptor = FetchDescriptor<WeeklySummaryEntry>(
            predicate: #Predicate<WeeklySummaryEntry> { entry in
                entry.weekStart == weekStart
            }
        )
        return (try? context.fetch(descriptor).isEmpty) ?? true
    }

    /// Generate weekly summary for the current user
    @MainActor
    func generateWeeklySummary(
        userName: String,
        isPro: Bool,
        context: ModelContext
    ) async -> WeeklySummaryEntry? {
        // Free tier: max 1 summary per month
        if !isPro && !canGenerateFreeSummary(context: context) {
            return nil
        }

        let weekStart = Date().startOfWeek
        let weekEnd = Calendar.current.date(byAdding: .day, value: 7, to: weekStart) ?? Date()

        let descriptor = FetchDescriptor<GratitudeEntry>(
            predicate: #Predicate<GratitudeEntry> { entry in
                entry.createdAt >= weekStart && entry.createdAt < weekEnd
            },
            sortBy: [SortDescriptor(\.createdAt)]
        )
        let gratitudes = (try? context.fetch(descriptor)) ?? []
        guard gratitudes.count >= 3 else { return nil } // Need minimum data

        // Analyze
        let topTopics = extractTopTopics(from: gratitudes, limit: 3)
        let dominantEmoji = findDominantEmoji(in: gratitudes)
        let sentimentTrend = analyzeSentimentTrend(gratitudes)

        // Generate narrative (cloud or local fallback)
        let narrative = await generateNarrative(
            gratitudes: gratitudes,
            topTopics: topTopics,
            userName: userName,
            sentimentTrend: sentimentTrend
        )

        let summary = WeeklySummaryEntry(
            weekStart: weekStart,
            narrative: narrative,
            topTopics: topTopics,
            sentimentTrend: sentimentTrend,
            dominantEmoji: dominantEmoji
        )
        context.insert(summary)
        try? context.save()
        return summary
    }

    // MARK: - Free Tier Gate
    private func canGenerateFreeSummary(context: ModelContext) -> Bool {
        let monthStart = Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month], from: Date())
        ) ?? Date()

        let descriptor = FetchDescriptor<WeeklySummaryEntry>(
            predicate: #Predicate<WeeklySummaryEntry> { entry in
                entry.createdAt >= monthStart
            }
        )
        let count = (try? context.fetch(descriptor).count) ?? 0
        return count < 1
    }

    // MARK: - Topic Extraction
    private func extractTopTopics(from entries: [GratitudeEntry], limit: Int) -> [String] {
        let stopWords: Set<String> = [
            "hoy", "agradezco", "por", "que", "una", "uno", "del", "los", "las",
            "con", "para", "como", "más", "muy", "fue", "ser", "este", "esta",
            "eso", "esa", "the", "and", "for", "with", "que", "estar", "estoy",
            "tengo", "hacer", "puedo", "tener", "estaba", "había", "también",
        ]

        var wordCounts: [String: Int] = [:]
        for entry in entries {
            let words = entry.text.lowercased()
                .components(separatedBy: .alphanumerics.inverted)
                .filter { $0.count > 3 && !stopWords.contains($0) }
            for word in words {
                wordCounts[word, default: 0] += 1
            }
        }

        return wordCounts.sorted { $0.value > $1.value }
            .prefix(limit)
            .map { $0.key.capitalized }
    }

    // MARK: - Emoji Analysis
    private func findDominantEmoji(in entries: [GratitudeEntry]) -> String {
        let emojis = entries.map(\.emoji).filter { !$0.isEmpty }
        guard !emojis.isEmpty else { return "🌿" }

        let counts = Dictionary(grouping: emojis, by: { $0 }).mapValues(\.count)
        return counts.max { $0.value < $1.value }?.key ?? "🌿"
    }

    // MARK: - Sentiment Trend
    private func analyzeSentimentTrend(_ entries: [GratitudeEntry]) -> String {
        let scores = entries.compactMap(\.sentimentScore)
        guard !scores.isEmpty else { return "neutral" }

        let avg = scores.reduce(0, +) / Double(scores.count)

        switch avg {
        case 0.7...:
            return "ascending"
        case 0.4..<0.7:
            return "stable"
        default:
            return "reflective"
        }
    }

    // MARK: - Narrative Generation
    private func generateNarrative(
        gratitudes: [GratitudeEntry],
        topTopics: [String],
        userName: String,
        sentimentTrend: String
    ) async -> String {
        // Try cloud first
        if let cloudNarrative = await AICoachService.shared.getWeeklySummary(
            gratitudes: gratitudes.map(\.text),
            userName: userName
        ) {
            return cloudNarrative
        }

        // Local fallback — warm, personal tone per PRD
        return generateLocalNarrative(
            topics: topTopics,
            userName: userName,
            entryCount: gratitudes.count,
            trend: sentimentTrend
        )
    }

    private func generateLocalNarrative(
        topics: [String],
        userName: String,
        entryCount: Int,
        trend: String
    ) -> String {
        let name = userName.isEmpty ? "tú" : userName

        let trendPhrase: String
        switch trend {
        case "ascending":
            trendPhrase = "Tu semana tuvo un tono luminoso — algo estaba creciendo dentro."
        case "reflective":
            trendPhrase = "Notaste momentos más introspectivos esta semana, y eso también tiene su belleza."
        default:
            trendPhrase = "Mantuviste un ritmo suave, presente, constante."
        }

        if topics.count >= 2 {
            return "Esta semana, \(name), tu mente estuvo en dos lugares: \(topics[0].lowercased()) y \(topics[1].lowercased()). \(trendPhrase) Escribiste \(entryCount) momentos de gratitud — cada uno una pequeña semilla. 🌱"
        } else if topics.count == 1 {
            return "Esta semana, \(name), \(topics[0].lowercased()) fue un hilo recurrente en tu gratitud. \(trendPhrase) \(entryCount) momentos capturados. Sigue notando lo que te sostiene. 🌿"
        } else {
            return "\(name), esta semana dejaste \(entryCount) pequeñas huellas de gratitud. \(trendPhrase) Cada una cuenta. ✨"
        }
    }
}
