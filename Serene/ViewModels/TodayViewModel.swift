import SwiftUI
import SwiftData

@MainActor
final class TodayViewModel: ObservableObject {
    @Published var baseGratitudes: [Int: Gratitude] = [:]
    @Published var extraGratitudes: [Int: Gratitude] = [:]
    @Published var justCompletedBase = false

    private let coachService = AICoachService()

    // MARK: - Greeting

    var greetingTime: String {
        let hour = Calendar.current.component(.hour, from: .now)
        return switch hour {
        case 5..<12: "Buenos dias"
        case 12..<18: "Buenas tardes"
        default: "Buenas noches"
        }
    }

    func greeting(for name: String) -> String {
        let seasonEmoji = seasonalEmoji
        return name.isEmpty ? "Hola \(seasonEmoji)" : "Hola, \(name) \(seasonEmoji)"
    }

    private var seasonalEmoji: String {
        let month = Calendar.current.component(.month, from: .now)
        return switch month {
        case 3...5: "🌸"
        case 6...8: "☀️"
        case 9...11: "🍂"
        default: "❄️"
        }
    }

    // MARK: - Streak

    var currentWeekday: Int {
        let weekday = Calendar.current.component(.weekday, from: .now)
        // Convert Sunday=1...Saturday=7 to Monday=0...Sunday=6
        return (weekday + 5) % 7
    }

    var completedDays: Set<Int> {
        // Placeholder — will be populated from SwiftData
        Set([currentWeekday])
    }

    // MARK: - Gratitudes

    func gratitude(at index: Int) -> Gratitude? {
        baseGratitudes[index]
    }

    func extraGratitude(at index: Int) -> Gratitude? {
        extraGratitudes[index]
    }

    func saveGratitude(text: String, emoji: GratitudeEmoji, slot: GratitudeSlot, completion: @escaping (String) -> Void) {
        let gratitude = Gratitude(
            text: text,
            emoji: emoji,
            slotIndex: slot.index,
            isExtra: slot.isExtra
        )

        if slot.isExtra {
            extraGratitudes[slot.index] = gratitude
        } else {
            baseGratitudes[slot.index] = gratitude
            if baseGratitudes.count == Gratitude.baseSlotCount {
                justCompletedBase = true
            }
        }

        // Get coach response
        coachService.generateResponse(for: text, emoji: emoji) { response in
            gratitude.aiResponse = response
            completion(response)
        }
    }
}
