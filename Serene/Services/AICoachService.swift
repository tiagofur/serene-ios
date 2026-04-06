import Foundation

final class AICoachService {
    /// Generate a personalized coach response for a gratitude entry.
    /// For MVP: returns a local placeholder response.
    /// In production: calls the Go backend which proxies to DeepSeek V3 / Gemini Flash.
    func generateResponse(for gratitudeText: String, emoji: GratitudeEmoji, completion: @escaping (String) -> Void) {
        // Simulate network delay for typing effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            let response = Self.localResponse(for: gratitudeText, emoji: emoji)
            completion(response)
        }
    }

    func generateResponse(for gratitudeText: String, emoji: GratitudeEmoji) async -> String {
        // TODO: Replace with actual API call to /ai/coach
        try? await Task.sleep(for: .seconds(1.2))
        return Self.localResponse(for: gratitudeText, emoji: emoji)
    }

    // MARK: - Local responses (MVP placeholder)

    private static func localResponse(for text: String, emoji: GratitudeEmoji) -> String {
        let responses: [GratitudeEmoji: [String]] = [
            .happy: [
                "Que bonito es reconocer los momentos que te hacen sonreir. Esa alegria que sientes es real y merece ser celebrada.",
                "Me encanta que puedas ver la belleza en tu dia. Esos momentos de felicidad son los que construyen una vida plena.",
            ],
            .grateful: [
                "La gratitud que sientes es poderosa. Cada vez que reconoces algo bueno, tu cerebro aprende a encontrar mas.",
                "Notar las cosas buenas es un superpoder. Y tu lo estas ejercitando ahora mismo.",
            ],
            .neutral: [
                "A veces los momentos mas simples son los mas significativos. Gracias por tomarte el tiempo de notarlos.",
                "No todo tiene que ser extraordinario para merecer gratitud. Lo cotidiano tambien cuenta, y mucho.",
            ],
            .reflective: [
                "Me gusta que te tomes un momento para reflexionar. Esa pausa consciente es lo que separa vivir de solo existir.",
                "La reflexion es un acto de amor propio. Estas construyendo una relacion mas profunda contigo.",
            ],
            .tough: [
                "Encontrar gratitud en los dias dificiles requiere mucha fuerza. Eso dice mucho de ti.",
                "Los dias dificiles tambien tienen luz, y tu la estas encontrando. Eso es resiliencia real.",
            ],
        ]

        let emojiResponses = responses[emoji] ?? responses[.neutral]!
        return emojiResponses.randomElement()!
    }
}
