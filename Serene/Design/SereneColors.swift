import SwiftUI

// MARK: - Serene Color System
// "Tierra organica" aesthetic — warm, natural, never clinical

struct SereneColors {
    // MARK: - Light Mode
    enum Light {
        static let background = Color(hex: "FDFAF6")
        static let surface = Color(hex: "F4EFE8")
        static let cardElevated = Color(hex: "FFFFFF")

        static let sage = Color(hex: "5A7A6B")
        static let sageSoft = Color(hex: "E0EDE7")
        static let arena = Color(hex: "C4956A")
        static let arenaSoft = Color(hex: "F5EAD8")
        static let rosa = Color(hex: "C0706E")
        static let rosaSoft = Color(hex: "F5E4E3")

        static let accentEarth = Color(hex: "7C6E5A")

        static let textPrimary = Color(hex: "2D2420")
        static let textSecondary = Color(hex: "7C6E5A")
        static let textTertiary = Color(hex: "9E8A78")

        static let borderDefault = Color(hex: "D4C5B0")
    }

    // MARK: - Dark Mode
    enum Dark {
        static let background = Color(hex: "17130F")
        static let surface = Color(hex: "221C16")
        static let cardElevated = Color(hex: "2C2419")

        static let sage = Color(hex: "8BBCA8")
        static let sageSoft = Color(hex: "2A3D33")
        static let arena = Color(hex: "E0A87A")
        static let arenaSoft = Color(hex: "3D2E1F")
        static let rosa = Color(hex: "D98F8D")
        static let rosaSoft = Color(hex: "3D2525")

        static let accentEarth = Color(hex: "B09A8C")

        static let textPrimary = Color(hex: "F2EBE3")
        static let textSecondary = Color(hex: "B09A8C")
        static let textTertiary = Color(hex: "6E5E54")

        static let borderDefault = Color(hex: "3A2E22")
    }
}

// MARK: - Adaptive Colors (auto light/dark)
extension SereneColors {
    static func background(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.background : Light.background
    }
    static func surface(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.surface : Light.surface
    }
    static func cardElevated(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.cardElevated : Light.cardElevated
    }
    static func sage(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.sage : Light.sage
    }
    static func sageSoft(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.sageSoft : Light.sageSoft
    }
    static func arena(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.arena : Light.arena
    }
    static func arenaSoft(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.arenaSoft : Light.arenaSoft
    }
    static func rosa(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.rosa : Light.rosa
    }
    static func rosaSoft(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.rosaSoft : Light.rosaSoft
    }
    static func accentEarth(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.accentEarth : Light.accentEarth
    }
    static func textPrimary(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.textPrimary : Light.textPrimary
    }
    static func textSecondary(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.textSecondary : Light.textSecondary
    }
    static func textTertiary(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.textTertiary : Light.textTertiary
    }
    static func borderDefault(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Dark.borderDefault : Light.borderDefault
    }
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
