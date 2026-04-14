---
tags: [model, code]
file: Serene/Models/UserProfile.swift
---

# UserProfile

Perfil del usuario. Hoy duplicado parcialmente con [[AppState]] para acceso síncrono.

## Schema

```swift
@Model
final class UserProfile {
    var id: UUID
    var name: String
    var email: String
    var locale: String                // "es", "en", "pt-BR"
    var tier: String                  // "free" | "pro"
    var trialEndsAt: Date?
    var reminderTime: Date?
    var createdAt: Date
}
```

## Computed

```swift
var isPro: Bool {
    if tier == "pro" { return true }
    if let trialEnd = trialEndsAt, trialEnd > Date() { return true }
    return false
}

var isTrialActive: Bool {
    guard let trialEnd = trialEndsAt else { return false }
    return trialEnd > Date()
}
```

## ⚠️ Deuda técnica

- AppState también tiene `userName`, `userTier` (UserDefaults)
- Razón: SwiftUI necesita acceso síncrono sin `@Query`
- Solución futura: `@Observable` wrapper

Ver [[Technical Debt]].

## 🔗 Relacionados
- [[Data Models]]
- [[AuthService]]
- [[Monetization Model]]
