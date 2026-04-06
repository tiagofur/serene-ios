import SwiftUI

extension Font {
    // MARK: - DM Serif Display (emotional moments)
    static func serifDisplay(_ size: CGFloat) -> Font {
        .custom("DMSerifDisplay-Regular", size: size)
    }

    // MARK: - Plus Jakarta Sans (functional)
    static func jakarta(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let name: String = switch weight {
        case .bold: "PlusJakartaSans-Bold"
        case .semibold: "PlusJakartaSans-SemiBold"
        case .medium: "PlusJakartaSans-Medium"
        default: "PlusJakartaSans-Regular"
        }
        return .custom(name, size: size)
    }

    // MARK: - Semantic tokens
    /// 28-32pt — Saludo del usuario, titulos grandes, unlock
    static let display = Font.serifDisplay(28)
    static let displayLarge = Font.serifDisplay(32)

    /// 18-22pt SemiBold — Titulos de seccion
    static let heading = Font.jakarta(20, weight: .semibold)
    static let headingSmall = Font.jakarta(18, weight: .semibold)
    static let headingLarge = Font.jakarta(22, weight: .semibold)

    /// 14-15pt Regular — Texto de gratitudes, respuestas del coach
    static let body = Font.jakarta(15)
    static let bodySmall = Font.jakarta(14)

    /// 11-12pt Medium — Metadata, counters, tags
    static let label = Font.jakarta(12, weight: .medium)
    static let labelSmall = Font.jakarta(11, weight: .medium)

    /// 10pt Medium — Status bar, tab labels
    static let micro = Font.jakarta(10, weight: .medium)
}
