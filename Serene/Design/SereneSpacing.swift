import SwiftUI

enum Spacing {
    /// 4px — Gap minimo entre elementos inline
    static let xs: CGFloat = 4
    /// 8px — Gap interno de components pequenos
    static let sm: CGFloat = 8
    /// 16px — Padding interno de cards y slots
    static let md: CGFloat = 16
    /// 24px — Separacion entre secciones
    static let lg: CGFloat = 24
    /// 40px — Espaciado de pantalla, margenes principales
    static let xl: CGFloat = 40
}

enum CornerRadius {
    /// 8px — Botones pequenos, pills, badges
    static let sm: CGFloat = 8
    /// 12px — Cards, coach reply, streak card
    static let md: CGFloat = 12
    /// 16px — Slots de gratitud, overlays, bottom sheet
    static let lg: CGFloat = 16
    /// 24px — Extra slots desbloqueados, modal principal
    static let xl: CGFloat = 24
}

enum BorderWidth {
    /// 0.5px — Borders en estado normal
    static let `default`: CGFloat = 0.5
    /// 1.5px — Slot activo, extra desbloqueado
    static let emphasis: CGFloat = 1.5
}
