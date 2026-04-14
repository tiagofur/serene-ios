import SwiftUI

// MARK: - Serene Theme Modifiers
// Consistent styling helpers that respect light/dark mode across the app

struct SereneSurfaceModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    let cornerRadius: CGFloat
    let elevated: Bool

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(elevated
                          ? SereneColors.cardElevated(colorScheme)
                          : SereneColors.surface(colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(SereneColors.borderDefault(colorScheme), lineWidth: BorderWidth.default)
                    )
            )
    }
}

struct SerenePrimaryButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme
    let isEnabled: Bool

    init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .sereneBody(14)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .fill(isEnabled
                          ? SereneColors.sage(colorScheme)
                          : SereneColors.borderDefault(colorScheme))
            )
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct SereneSecondaryButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .sereneBody(14)
            .fontWeight(.medium)
            .foregroundColor(SereneColors.sage(colorScheme))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .stroke(SereneColors.sage(colorScheme), lineWidth: BorderWidth.emphasis)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

// MARK: - Subtle Press Feedback
struct SerenePressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension View {
    func sereneSurface(cornerRadius: CGFloat = Radius.md, elevated: Bool = false) -> some View {
        modifier(SereneSurfaceModifier(cornerRadius: cornerRadius, elevated: elevated))
    }
}

// MARK: - App Appearance Preference
enum AppAppearance: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var label: String {
        switch self {
        case .system: return "Sistema"
        case .light: return "Claro"
        case .dark: return "Oscuro"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
