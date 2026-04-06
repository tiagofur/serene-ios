import Foundation

enum GratitudeEmoji: String, Codable, CaseIterable {
    case happy = "happy"
    case grateful = "grateful"
    case neutral = "neutral"
    case reflective = "reflective"
    case tough = "tough"

    var symbol: String {
        switch self {
        case .happy: "😊"
        case .grateful: "🙏"
        case .neutral: "😌"
        case .reflective: "🤔"
        case .tough: "💪"
        }
    }

    var label: String {
        switch self {
        case .happy: "Feliz"
        case .grateful: "Agradecido"
        case .neutral: "Tranquilo"
        case .reflective: "Reflexivo"
        case .tough: "Fuerte"
        }
    }
}
