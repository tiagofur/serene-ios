---
tags: [model, code]
file: Serene/Models/GratitudeEntry.swift
---

# GratitudeEntry

Modelo principal del producto. Una entrada individual de gratitud.

## Schema

```swift
@Model
final class GratitudeEntry {
    var id: UUID
    var text: String                  // Contenido escrito por el usuario
    var emoji: String                 // Mood seleccionado (1 de 5)
    var photoURL: String?             // TODO: photo attachment
    var aiResponse: String?           // Coach response (cloud o local)
    var sentimentScore: Double?       // [0, 1] o nil si no analizado
    var slotIndex: Int                // 0-2 base, 3-4 extras
    var isExtra: Bool
    var createdAt: Date
}
```

## Computed

```swift
var isCompleted: Bool {
    !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
}
```

## Predicates helper

```swift
static var todayPredicate: Predicate<GratitudeEntry> {
    let calendar = Calendar.current
    let startOfDay = calendar.startOfDay(for: Date())
    let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
    return #Predicate<GratitudeEntry> { entry in
        entry.createdAt >= startOfDay && entry.createdAt < endOfDay
    }
}
```

## Mood enum

```swift
enum GratitudeMood: String, CaseIterable, Identifiable {
    case happy = "😊"
    case grateful = "🙏"
    case calm = "😌"
    case loved = "❤️"
    case reflective = "🤔"

    var label: String { ... }  // ES localized
}
```

## 🔗 Usado por

- [[GratitudeService]] (CRUD)
- [[TodayViewModel]] (today's entries)
- [[PatternDetectionService]] (analysis)
- [[WeeklySummaryService]] (analysis)
- [[HistoryView]] (display)
- [[PDFExportService]] (export)

## 🔗 Relacionados
- [[Data Models]]
- [[3+2 Mechanic]]
- [[GratitudeService]]
