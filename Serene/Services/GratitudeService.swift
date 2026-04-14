import Foundation
import SwiftData

// MARK: - Gratitude API DTOs
struct CreateGratitudeRequest: Encodable {
    let text: String
    let emoji: String
    let slotIndex: Int
    let isExtra: Bool
}

struct GratitudeResponse: Decodable {
    let id: String
    let text: String
    let emoji: String
    let aiResponse: String?
    let sentimentScore: Double?
    let createdAt: String
}

// MARK: - Gratitude Service
final class GratitudeService {
    static let shared = GratitudeService()

    private init() {}

    /// Save gratitude locally and attempt to sync with backend
    func saveGratitude(
        text: String,
        emoji: String,
        slotIndex: Int,
        isExtra: Bool,
        context: ModelContext
    ) async -> GratitudeEntry {
        let entry = GratitudeEntry(
            text: text,
            emoji: emoji,
            slotIndex: slotIndex,
            isExtra: isExtra
        )
        context.insert(entry)

        // Try to sync with backend
        do {
            let response: GratitudeResponse = try await APIService.shared.request(
                endpoint: "/gratitudes",
                method: "POST",
                body: CreateGratitudeRequest(
                    text: text,
                    emoji: emoji,
                    slotIndex: slotIndex,
                    isExtra: isExtra
                )
            )
            entry.aiResponse = response.aiResponse
            entry.sentimentScore = response.sentimentScore
        } catch {
            // Offline-first: entry is saved locally, will sync later
            print("Backend sync failed (offline mode): \(error.localizedDescription)")
        }

        return entry
    }

    /// Fetch today's gratitudes from local storage
    func todayGratitudes(context: ModelContext) -> [GratitudeEntry] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let descriptor = FetchDescriptor<GratitudeEntry>(
            predicate: #Predicate<GratitudeEntry> { entry in
                entry.createdAt >= startOfDay && entry.createdAt < endOfDay
            },
            sortBy: [SortDescriptor(\.slotIndex)]
        )

        return (try? context.fetch(descriptor)) ?? []
    }

    /// Fetch gratitudes for a given date range
    func gratitudes(from startDate: Date, to endDate: Date, context: ModelContext) -> [GratitudeEntry] {
        let descriptor = FetchDescriptor<GratitudeEntry>(
            predicate: #Predicate<GratitudeEntry> { entry in
                entry.createdAt >= startDate && entry.createdAt < endDate
            },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        return (try? context.fetch(descriptor)) ?? []
    }
}
