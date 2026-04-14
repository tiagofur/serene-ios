import Foundation

// MARK: - Difficult Mode Service
// Per PRD Section 3.2: "Modo dificil (guia cuando no encuentras nada)"
// Conversational AI that guides the user through blocks via gentle prompting

struct DifficultModeMessage: Identifiable, Equatable {
    let id = UUID()
    let role: Role
    let content: String
    let timestamp: Date

    enum Role: String {
        case coach
        case user
    }
}

struct DifficultModeRequest: Encodable {
    let userName: String
    let conversationHistory: [ConversationTurn]
    let currentMessage: String
}

struct ConversationTurn: Encodable {
    let role: String
    let content: String
}

struct DifficultModeResponse: Decodable {
    let response: String
    let suggestedGratitude: String?
}

final class DifficultModeService {
    static let shared = DifficultModeService()
    private init() {}

    /// Opening message from the coach when the user enters difficult mode
    func openingMessage(userName: String) -> String {
        let openers = [
            "Hola \(userName), algunos días nos encuentran vacíos. Está bien. No tienes que forzar nada. Solo respirá un momento conmigo. ¿Cómo te sientes ahora mismo?",
            "Oye \(userName). No todos los días salen las palabras. Empecemos despacio: ¿qué fue lo más ligero de tu día, aunque sea pequeño?",
            "\(userName), hay días en que agradecer cuesta — y eso también es información valiosa. Cuéntame, sin filtros: ¿qué ha sido hoy para ti?",
        ]
        return openers.randomElement() ?? openers[0]
    }

    /// Get the next coach response given conversation history
    func getResponse(
        userName: String,
        history: [DifficultModeMessage],
        userMessage: String
    ) async -> DifficultModeResponse {
        let turns = history.map { ConversationTurn(role: $0.role.rawValue, content: $0.content) }

        do {
            let response: DifficultModeResponse = try await APIService.shared.request(
                endpoint: "/ai/difficult-mode",
                method: "POST",
                body: DifficultModeRequest(
                    userName: userName,
                    conversationHistory: turns,
                    currentMessage: userMessage
                )
            )
            return response
        } catch {
            return localFallback(userMessage: userMessage, history: history, userName: userName)
        }
    }

    // MARK: - Local Fallback
    // A small conversation tree that mimics Socratic gentleness when offline

    private func localFallback(
        userMessage: String,
        history: [DifficultModeMessage],
        userName: String
    ) -> DifficultModeResponse {
        let turnCount = history.filter { $0.role == .user }.count
        let message = userMessage.lowercased()

        // Turn 0 → 1: Validate and redirect to body
        if turnCount == 0 {
            let responses = [
                "Escucho eso, \(userName). No hace falta que nada tenga sentido aún. ¿Qué notaste en tu cuerpo hoy? Un respiro, un cambio de luz, el peso de un café caliente…",
                "Gracias por decirlo así, \(userName). ¿Hubo un momento — aunque fuera de 10 segundos — donde tu mente se quedó quieta?",
            ]
            return DifficultModeResponse(response: responses.randomElement()!, suggestedGratitude: nil)
        }

        // Turn 2: Look for micro-moments
        if turnCount == 1 {
            if message.contains("nada") || message.contains("nothing") || message.count < 15 {
                return DifficultModeResponse(
                    response: "Está bien. Intentemos algo más pequeño: ¿estás en un espacio seco, abrigado, con algo de luz? A veces la gratitud empieza ahí — en lo que damos por hecho.",
                    suggestedGratitude: nil
                )
            }
            return DifficultModeResponse(
                response: "Eso que describes es real. ¿Quién o qué te permitió que eso pasara — aunque sea indirectamente?",
                suggestedGratitude: nil
            )
        }

        // Turn 3+: Help crystalize into a gratitude
        let suggestion = extractGratitudeCandidate(from: history + [DifficultModeMessage(role: .user, content: userMessage, timestamp: Date())])
        return DifficultModeResponse(
            response: "\(userName), lo que acabas de decir ya es gratitud — solo que no la llamamos así. ¿Quieres que lo guardemos juntos?",
            suggestedGratitude: suggestion
        )
    }

    private func extractGratitudeCandidate(from history: [DifficultModeMessage]) -> String {
        // Find the most substantive user message
        let userMessages = history.filter { $0.role == .user && $0.content.count > 20 }
        if let best = userMessages.max(by: { $0.content.count < $1.content.count }) {
            let trimmed = best.content.trimmingCharacters(in: .whitespacesAndNewlines)
            return "Hoy agradezco \(trimmed.lowercased().prefix(1) == "q" ? "" : "")\(trimmed)"
        }
        return "Hoy agradezco estar presente, incluso cuando cuesta."
    }
}
