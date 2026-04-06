import SwiftUI

extension Color {
    // MARK: - Backgrounds
    static let backgroundPrimary = Color("BackgroundPrimary")
    static let surface = Color("Surface")
    static let cardElevated = Color("CardElevated")

    // MARK: - Accents
    static let sage = Color("Sage")
    static let sageSoft = Color("SageSoft")
    static let arena = Color("Arena")
    static let arenaSoft = Color("ArenaSoft")
    static let rosa = Color("Rosa")
    static let rosaSoft = Color("RosaSoft")
    static let earthAccent = Color("EarthAccent")

    // MARK: - Text
    static let textPrimary = Color("TextPrimary")
    static let textSecondary = Color("TextSecondary")
    static let textTertiary = Color("TextTertiary")

    // MARK: - Border
    static let borderDefault = Color("BorderDefault")
}

// MARK: - Programmatic fallbacks (used if asset catalog colors not loaded)

extension Color {
    enum Serene {
        // Light mode values
        static let backgroundPrimary = Color(hex: 0xFDFAF6)
        static let surface = Color(hex: 0xF4EFE8)
        static let cardElevated = Color(hex: 0xFFFFFF)
        static let earthAccent = Color(hex: 0x7C6E5A)
        static let sage = Color(hex: 0x5A7A6B)
        static let sageSoft = Color(hex: 0xE0EDE7)
        static let arena = Color(hex: 0xC4956A)
        static let arenaSoft = Color(hex: 0xF5EAD8)
        static let rosa = Color(hex: 0xC0706E)
        static let rosaSoft = Color(hex: 0xF5E4E3)
        static let textPrimary = Color(hex: 0x2D2420)
        static let textSecondary = Color(hex: 0x7C6E5A)
        static let textTertiary = Color(hex: 0x9E8A78)
        static let borderDefault = Color(hex: 0xD4C5B0)

        // Dark mode values
        enum Dark {
            static let backgroundPrimary = Color(hex: 0x17130F)
            static let surface = Color(hex: 0x221C16)
            static let cardElevated = Color(hex: 0x2C2419)
            static let sage = Color(hex: 0x8BBCA8)
            static let arena = Color(hex: 0xE0A87A)
            static let rosa = Color(hex: 0xD98F8D)
            static let textPrimary = Color(hex: 0xF2EBE3)
            static let textSecondary = Color(hex: 0xB09A8C)
            static let textTertiary = Color(hex: 0x6E5E54)
            static let borderDefault = Color(hex: 0x3A2E22)
        }
    }
}

extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: opacity
        )
    }
}
