---
tags: [model, code]
file: Serene/Models/PatternEntry.swift
---

# PatternEntry

Snapshot de patrones detectados. Hoy solo `type=connection`.

## Schema

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

## Uso actual

`type = "connection"`: snapshots de [[Unexpected Connections]] persistidos por [[PatternDetectionService]].snapshotConnections().

Las nuevas reemplazan las viejas (delete-then-insert).

## Uso futuro

- `type = "topic"`: top recurring topics (hoy se calcula on-the-fly)
- `type = "emotion"`: emotional pattern detection
- `acknowledged`: para mostrar/ocultar patterns ya vistos

## 🔗 Relacionados
- [[Pattern Detection]]
- [[PatternDetectionService]]
- [[Data Models]]
