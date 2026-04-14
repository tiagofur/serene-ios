import Foundation

// MARK: - AI Coach DTOs
struct CoachRequest: Encodable {
    let gratitudeText: String
    let emoji: String
    let userName: String
    let previousGratitudes: [String]
}

struct CoachResponse: Decodable {
    let response: String
}

// MARK: - AI Coach Service
final class AICoachService {
    static let shared = AICoachService()

    private init() {}

    /// Get AI coach response for a gratitude entry
    func getCoachResponse(
        gratitudeText: String,
        emoji: String,
        userName: String,
        previousGratitudes: [String] = []
    ) async -> String {
        // Try API first
        do {
            let response: CoachResponse = try await APIService.shared.request(
                endpoint: "/ai/coach",
                method: "POST",
                body: CoachRequest(
                    gratitudeText: gratitudeText,
                    emoji: emoji,
                    userName: userName,
                    previousGratitudes: previousGratitudes
                )
            )
            return response.response
        } catch {
            // Fallback to local responses when offline
            return generateLocalResponse(for: gratitudeText, userName: userName)
        }
    }

    /// Generate a warm local response as fallback
    private func generateLocalResponse(for text: String, userName: String) -> String {
        let responses = [
            "Qué bonito que notes eso, \(userName). Los pequeños momentos son los que más cuentan. 🌿",
            "Me encanta que hayas parado a agradecer eso, \(userName). Es una señal de que estás presente. ✨",
            "\(userName), la gratitud que sientes ahora es real y valiosa. Guárdala en tu corazón. 🙏",
            "Eso que compartes dice mucho de ti, \(userName). Estás cultivando algo hermoso. 🌱",
            "Gracias por compartir eso, \(userName). Reconocer lo bueno es el primer paso hacia más. 💚",
            "\(userName), qué momento tan especial. A veces lo más simple es lo más profundo. 🍃",
            "Me alegra que hayas notado eso hoy, \(userName). Tu capacidad de agradecer te hace más fuerte. 🌻",
        ]
        return responses.randomElement() ?? responses[0]
    }

    /// Get weekly summary narrative
    func getWeeklySummary(
        gratitudes: [String],
        userName: String
    ) async -> String? {
        struct SummaryRequest: Encodable {
            let gratitudes: [String]
            let userName: String
        }

        struct SummaryResponse: Decodable {
            let narrative: String
            let topTopics: [String]
            let sentimentTrend: String
        }

        do {
            let response: SummaryResponse = try await APIService.shared.request(
                endpoint: "/insights/weekly",
                method: "GET"
            )
            return response.narrative
        } catch {
            return nil
        }
    }
}
