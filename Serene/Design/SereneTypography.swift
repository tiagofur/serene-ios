import SwiftUI

// MARK: - Serene Typography System
// DM Serif Display: emotional moments (greetings, celebrations, summaries)
// Plus Jakarta Sans: functional UI (buttons, labels, body text)

struct SereneFont {
    // MARK: - DM Serif Display (emotional)
    static func display(_ size: CGFloat = 28) -> Font {
        .custom("DMSerifDisplay-Regular", size: size, relativeTo: .title)
    }

    // MARK: - Plus Jakarta Sans (functional)
    static func heading(_ size: CGFloat = 20) -> Font {
        .custom("PlusJakartaSans-SemiBold", size: size, relativeTo: .headline)
    }

    static func body(_ size: CGFloat = 15) -> Font {
        .custom("PlusJakartaSans-Regular", size: size, relativeTo: .body)
    }

    static func label(_ size: CGFloat = 12) -> Font {
        .custom("PlusJakartaSans-Medium", size: size, relativeTo: .caption)
    }

    static func micro(_ size: CGFloat = 10) -> Font {
        .custom("PlusJakartaSans-Medium", size: size, relativeTo: .caption2)
    }

    // MARK: - System fallbacks (until custom fonts are bundled)
    static func displayFallback(_ size: CGFloat = 28) -> Font {
        .system(size: size, weight: .regular, design: .serif)
    }

    static func headingFallback(_ size: CGFloat = 20) -> Font {
        .system(size: size, weight: .semibold, design: .default)
    }

    static func bodyFallback(_ size: CGFloat = 15) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }

    static func labelFallback(_ size: CGFloat = 12) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }

    static func microFallback(_ size: CGFloat = 10) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }
}

// MARK: - View Modifier for consistent text styles
extension View {
    func sereneDisplay(_ size: CGFloat = 28) -> some View {
        self.font(SereneFont.displayFallback(size))
    }

    func sereneHeading(_ size: CGFloat = 20) -> some View {
        self.font(SereneFont.headingFallback(size))
    }

    func sereneBody(_ size: CGFloat = 15) -> some View {
        self.font(SereneFont.bodyFallback(size))
    }

    func sereneLabel(_ size: CGFloat = 12) -> some View {
        self.font(SereneFont.labelFallback(size))
    }

    func sereneMicro(_ size: CGFloat = 10) -> some View {
        self.font(SereneFont.microFallback(size))
    }

    func sereneSectionHeader() -> some View {
        self
            .font(SereneFont.labelFallback(11))
            .textCase(.uppercase)
            .tracking(0.66)
    }
}
