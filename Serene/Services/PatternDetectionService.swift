import Foundation
import SwiftData
import NaturalLanguage

// MARK: - Pattern Detection Service
// Per PRD Section 3.5:
// - Unexpected connections: "Notamos que cuando agradeces naturaleza, tu semana mejora"
// - Language evolution: compare words 30 days ago vs now
// - Sentiment trend over time

struct EmotionalConnection: Identifiable {
    let id = UUID()
    let topic: String
    let sentimentLift: Double   // How much this topic improves sentiment vs baseline
    let occurrences: Int
    var narrative: String
}

struct LanguageEvolution {
    let previousPeriodTopWords: [String]
    let currentPeriodTopWords: [String]
    let newWords: [String]          // Words appearing now but not before
    let fadingWords: [String]       // Words used before, now rare
    let expansionCount: Int         // Count of meaningfully new vocabulary
}

struct SentimentPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double   // 0...1
    let entryCount: Int
}

// MARK: - Service

@MainActor
final class PatternDetectionService {
    static let shared = PatternDetectionService()
    private init() {}

    // Stop words reused across analyses
    private let stopWords: Set<String> = [
        "hoy", "agradezco", "por", "que", "una", "uno", "del", "los", "las",
        "con", "para", "como", "más", "muy", "fue", "ser", "este", "esta",
        "eso", "esa", "tengo", "estar", "también", "había", "pero", "sobre",
        "entre", "cuando", "donde", "porque", "estoy", "siento", "puedo",
        "quiero", "tener", "hacer", "sido", "estaba",
    ]

    // MARK: - Unexpected Connections

    func detectConnections(context: ModelContext, limit: Int = 3) -> [EmotionalConnection] {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        let descriptor = FetchDescriptor<GratitudeEntry>(
            predicate: #Predicate<GratitudeEntry> { entry in
                entry.createdAt >= thirtyDaysAgo
            },
            sortBy: [SortDescriptor(\.createdAt)]
        )
        guard let entries = try? context.fetch(descriptor), entries.count >= 10 else {
            return []
        }

        // Compute baseline sentiment
        let allScores = entries.compactMap(\.sentimentScore)
        let baseline = allScores.isEmpty ? 0.5 : (allScores.reduce(0, +) / Double(allScores.count))

        // For each meaningful word, compute the average sentiment of entries containing it
        var wordSentiment: [String: (sum: Double, count: Int)] = [:]
        for entry in entries {
            let score = entry.sentimentScore ?? analyzeSentiment(entry.text)
            let words = tokenize(entry.text)
            for word in words where word.count >= 4 && !stopWords.contains(word) {
                var current = wordSentiment[word] ?? (0, 0)
                current.sum += score
                current.count += 1
                wordSentiment[word] = current
            }
        }

        // Find words with meaningful lift over baseline and enough occurrences
        let connections = wordSentiment.compactMap { word, data -> EmotionalConnection? in
            guard data.count >= 3 else { return nil }
            let avg = data.sum / Double(data.count)
            let lift = avg - baseline
            guard lift >= 0.08 else { return nil } // Meaningful difference
            return EmotionalConnection(
                topic: word.capitalized,
                sentimentLift: lift,
                occurrences: data.count,
                narrative: narrativeForConnection(word: word, lift: lift, occurrences: data.count)
            )
        }
        .sorted { $0.sentimentLift > $1.sentimentLift }

        return Array(connections.prefix(limit))
    }

    private func narrativeForConnection(word: String, lift: Double, occurrences: Int) -> String {
        let intensity: String
        switch lift {
        case 0.2...: intensity = "notablemente más alto"
        case 0.12..<0.2: intensity = "más luminoso"
        default: intensity = "más tranquilo"
        }
        return "Cuando mencionas \(word), tu tono emocional es \(intensity). Ha aparecido \(occurrences) veces en los últimos 30 días."
    }

    // MARK: - Language Evolution

    func analyzeLanguageEvolution(context: ModelContext) -> LanguageEvolution? {
        let now = Date()
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: now) ?? now
        let sixtyDaysAgo = Calendar.current.date(byAdding: .day, value: -60, to: now) ?? now

        let recentDescriptor = FetchDescriptor<GratitudeEntry>(
            predicate: #Predicate<GratitudeEntry> { entry in
                entry.createdAt >= thirtyDaysAgo
            }
        )
        let previousDescriptor = FetchDescriptor<GratitudeEntry>(
            predicate: #Predicate<GratitudeEntry> { entry in
                entry.createdAt >= sixtyDaysAgo && entry.createdAt < thirtyDaysAgo
            }
        )

        guard let recent = try? context.fetch(recentDescriptor), !recent.isEmpty,
              let previous = try? context.fetch(previousDescriptor), !previous.isEmpty else {
            return nil
        }

        let currentCounts = wordFrequency(for: recent)
        let previousCounts = wordFrequency(for: previous)

        let currentTop = currentCounts.sorted { $0.value > $1.value }
            .prefix(8).map { $0.key.capitalized }
        let previousTop = previousCounts.sorted { $0.value > $1.value }
            .prefix(8).map { $0.key.capitalized }

        let currentSet = Set(currentCounts.keys)
        let previousSet = Set(previousCounts.keys)

        // Words that are significant in current but weren't before
        let newWords = currentCounts
            .filter { word, count in
                count >= 2 && (previousCounts[word] ?? 0) <= 1
            }
            .sorted { $0.value > $1.value }
            .prefix(5)
            .map { $0.key.capitalized }

        // Words that were common before and now rare
        let fadingWords = previousCounts
            .filter { word, count in
                count >= 3 && (currentCounts[word] ?? 0) <= 1
            }
            .sorted { $0.value > $1.value }
            .prefix(5)
            .map { $0.key.capitalized }

        let expansionCount = currentSet.subtracting(previousSet).count

        return LanguageEvolution(
            previousPeriodTopWords: Array(previousTop),
            currentPeriodTopWords: Array(currentTop),
            newWords: Array(newWords),
            fadingWords: Array(fadingWords),
            expansionCount: expansionCount
        )
    }

    // MARK: - Sentiment Series

    func sentimentSeries(context: ModelContext, days: Int = 30) -> [SentimentPoint] {
        let calendar = Calendar.current
        let since = calendar.date(byAdding: .day, value: -days, to: Date()) ?? Date()

        let descriptor = FetchDescriptor<GratitudeEntry>(
            predicate: #Predicate<GratitudeEntry> { entry in
                entry.createdAt >= since
            }
        )
        guard let entries = try? context.fetch(descriptor), !entries.isEmpty else {
            return []
        }

        // Group by day
        let grouped = Dictionary(grouping: entries) { entry in
            calendar.startOfDay(for: entry.createdAt)
        }

        return grouped.map { date, dayEntries in
            let scores = dayEntries.map { $0.sentimentScore ?? analyzeSentiment($0.text) }
            let avg = scores.reduce(0, +) / Double(scores.count)
            return SentimentPoint(date: date, value: avg, entryCount: dayEntries.count)
        }
        .sorted { $0.date < $1.date }
    }

    // MARK: - Private helpers

    private func tokenize(_ text: String) -> [String] {
        text.lowercased()
            .components(separatedBy: .alphanumerics.inverted)
            .filter { !$0.isEmpty }
    }

    private func wordFrequency(for entries: [GratitudeEntry]) -> [String: Int] {
        var counts: [String: Int] = [:]
        for entry in entries {
            let words = tokenize(entry.text)
            for word in words where word.count >= 4 && !stopWords.contains(word) {
                counts[word, default: 0] += 1
            }
        }
        return counts
    }

    /// Lightweight on-device sentiment using NaturalLanguage framework
    private func analyzeSentiment(_ text: String) -> Double {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        if let raw = sentiment?.rawValue, let score = Double(raw) {
            // NLTagger returns [-1, 1]. Normalize to [0, 1] with mild bias toward positive
            // since gratitudes are typically positive.
            return (score + 1) / 2
        }
        return 0.55 // Default slight positive
    }

    // MARK: - Persistence (snapshot detected patterns)

    func snapshotConnections(
        _ connections: [EmotionalConnection],
        context: ModelContext
    ) {
        // Remove prior "connection" patterns (keep only latest)
        let descriptor = FetchDescriptor<PatternEntry>(
            predicate: #Predicate<PatternEntry> { entry in
                entry.type == "connection"
            }
        )
        if let existing = try? context.fetch(descriptor) {
            for entry in existing { context.delete(entry) }
        }
        for connection in connections {
            let entry = PatternEntry(
                type: "connection",
                content: connection.narrative
            )
            context.insert(entry)
        }
        try? context.save()
    }
}
