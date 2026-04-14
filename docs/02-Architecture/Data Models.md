---
tags: [architecture, data, models]
updated: 2026-04-14
---

# Data Models

Modelos SwiftData del proyecto. Todos usan `@Model` macro.

## 📊 Diagrama de relaciones

```
UserProfile (1) ──┬── (N) GratitudeEntry
                  ├── (1) StreakData
                  ├── (N) WeeklySummaryEntry
                  └── (N) PatternEntry
```

> **Nota**: En la implementación actual, las relaciones formales `@Relationship` no están declaradas porque cada device tiene un solo usuario implícito. Si se añadieran cuentas familiares ([[v2.1]]), habría que reintroducir relaciones.

## 📁 Modelos

### [[GratitudeEntry]]
Entrada individual de gratitud.

```swift
@Model
final class GratitudeEntry {
    var id: UUID
    var text: String
    var emoji: String
    var photoURL: String?
    var aiResponse: String?
    var sentimentScore: Double?
    var slotIndex: Int       // 0-4
    var isExtra: Bool        // true para slots 3-4
    var createdAt: Date
}
```

**Indexes implícitos**: `createdAt` (sort por defecto)
**Predicates comunes**: `todayPredicate`, por rango de fechas

---

### [[UserProfile]]
Perfil del usuario actual.

```swift
@Model
final class UserProfile {
    var id: UUID
    var name: String
    var email: String
    var locale: String
    var tier: String          // "free" | "pro"
    var trialEndsAt: Date?
    var reminderTime: Date?
    var createdAt: Date

    var isPro: Bool           // computed
    var isTrialActive: Bool   // computed
}
```

**Notas**: Hoy se duplica info en `AppState` (UserDefaults) para acceso síncrono en SwiftUI. Considerar unificar en [[v2.0]].

---

### [[StreakData]]
Estado de racha singleton del usuario.

```swift
@Model
final class StreakData {
    var id: UUID
    var currentStreak: Int
    var longestStreak: Int
    var lastEntryDate: Date?
    var rescuesUsedThisMonth: Int
    var lastRescueDate: Date?

    var canRescue: Bool       // computed: < 1 used this month

    func recordEntry()
    func useRescue() -> Bool
    func checkMonthlyReset()
}
```

**Lógica de racha**:
- Si `lastEntryDate` == hoy → no-op (idempotente)
- Si `lastEntryDate` == ayer → `currentStreak += 1`
- Si más antigua → reset a 1

**Rescate**: 1 por mes calendario. Reset en `checkMonthlyReset()`.

---

### [[WeeklySummaryEntry]]
Resumen semanal generado.

```swift
@Model
final class WeeklySummaryEntry {
    var id: UUID
    var weekStart: Date           // Monday of week
    var narrative: String         // Coach narrative
    var topTopics: [String]       // ["Familia", "Trabajo", "Naturaleza"]
    var sentimentTrend: String    // "ascending" | "stable" | "reflective"
    var dominantEmoji: String
    var createdAt: Date
}
```

**Generación**: Ver [[WeeklySummaryService]]
- Free: 1/mes capped
- Pro: ilimitado, automático los lunes

---

### [[PatternEntry]]
Patrones detectados (snapshot de [[PatternDetectionService]]).

```swift
@Model
final class PatternEntry {
    var id: UUID
    var type: String              // "topic" | "emotion" | "connection"
    var content: String           // Narrativa o keyword
    var detectedAt: Date
    var acknowledged: Bool        // User dismissed?
}
```

**Uso actual**: Solo `type == "connection"` se usa (snapshot de `EmotionalConnection`).
**Futuro**: Expandir a `topic` y `emotion` types.

---

## 🔍 Patrones de query

### Today's entries
```swift
let calendar = Calendar.current
let startOfDay = calendar.startOfDay(for: Date())
let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
let predicate = #Predicate<GratitudeEntry> { entry in
    entry.createdAt >= startOfDay && entry.createdAt < endOfDay
}
```

### Date range con sort
```swift
let descriptor = FetchDescriptor<GratitudeEntry>(
    predicate: #Predicate<GratitudeEntry> { entry in
        entry.createdAt >= start && entry.createdAt < end
    },
    sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
)
```

### En SwiftUI Views
```swift
@Query(sort: \GratitudeEntry.createdAt, order: .reverse)
private var allGratitudes: [GratitudeEntry]
```

## ⚠️ Limitaciones conocidas

1. **Sin migration scripts**: SwiftData maneja schema migrations automáticas pero no hay tests de upgrade
2. **Sin encryption at rest**: SwiftData usa SQLite, en futuro se debe evaluar `NSPersistentStoreFileProtectionKey`
3. **Sin sync remoto explícito**: cada `@Model` tiene `id: UUID` para upsert futuro pero el sync no está implementado

## 🔗 Relacionados
- [[Tech Stack]]
- [[Offline-First Strategy]]
- [[GratitudeService]]
- [[ADR-001 - SwiftData over CoreData]]
