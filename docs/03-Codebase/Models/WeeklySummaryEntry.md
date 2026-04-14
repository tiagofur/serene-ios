---
tags: [model, code]
file: Serene/Models/WeeklySummaryEntry.swift
version_introduced: 1.1
---

# WeeklySummaryEntry

Resumen semanal generado por [[WeeklySummaryService]].

## Schema

```swift
@Model
final class WeeklySummaryEntry {
    var id: UUID
    var weekStart: Date              // Monday del week
    var narrative: String            // Texto del coach
    var topTopics: [String]          // ["Familia", "Trabajo", ...]
    var sentimentTrend: String       // "ascending" | "stable" | "reflective"
    var dominantEmoji: String
    var createdAt: Date
}
```

## Lifecycle

- **Generated**: Auto los lunes en `InsightsView.task` via [[WeeklySummaryService]]
- **Free gating**: 1/mes max
- **Pro**: ilimitado
- **Displayed**: [[InsightsView]] (latest) + [[WeeklySummaryDetailView]] (full)

## 🔗 Relacionados
- [[Weekly Summary]]
- [[WeeklySummaryService]]
- [[Data Models]]
