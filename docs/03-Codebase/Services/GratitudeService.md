---
tags: [service, code, data, offline]
file: Serene/Services/GratitudeService.swift
---

# GratitudeService

CRUD de gratitudes. Implementa la estrategia [[Offline-First Strategy]].

## Responsabilidades
- Guardar gratitudes (local first, cloud best-effort)
- Listar gratitudes de hoy
- Listar gratitudes en rango de fechas

## API Pública

```swift
final class GratitudeService {
    static let shared: GratitudeService

    func saveGratitude(
        text: String,
        emoji: String,
        slotIndex: Int,
        isExtra: Bool,
        context: ModelContext
    ) async -> GratitudeEntry

    func todayGratitudes(context: ModelContext) -> [GratitudeEntry]

    func gratitudes(from: Date, to: Date, context: ModelContext) -> [GratitudeEntry]
}
```

## Flujo de save

```
1. context.insert(GratitudeEntry(...))     ← Síncrono, en SQLite
2. POST /gratitudes (best-effort)
   ├── Success → entry.aiResponse = response.aiResponse
   │             entry.sentimentScore = response.sentimentScore
   └── Failure → entry queda con aiResponse=nil, será llenado por
                  AICoachService.localFallback en VM
3. Return entry (ya persistido)
```

Ver [[ADR-004 - Offline-First]] para racional completo.

## DTOs

```swift
struct CreateGratitudeRequest: Encodable {
    let text: String
    let emoji: String
    let slotIndex: Int
    let isExtra: Bool
}

struct GratitudeResponse: Decodable {
    let id, text, emoji: String
    let aiResponse: String?
    let sentimentScore: Double?
    let createdAt: String
}
```

## Patrones de query

### Today
Usa el predicado helper en [[GratitudeEntry]] (`todayPredicate`).

### Date range
```swift
FetchDescriptor<GratitudeEntry>(
    predicate: #Predicate { entry in
        entry.createdAt >= startDate && entry.createdAt < endDate
    },
    sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
)
```

## Limitaciones

- ❌ No batch sync (TODO: cuando se implemente [[Sync Engine]])
- ❌ No conflict resolution (no necesario hasta multi-device)
- ❌ El AI response viene en mismo POST → si cloud falla, AI fallback se hace en VM (split responsibility, considerar refactor)

## Tests pendientes
- [ ] Save offline → entry persists
- [ ] Save online → cloud response merged
- [ ] Today query timezone correctness

## 🔗 Relacionados
- [[GratitudeEntry]]
- [[APIService]]
- [[AICoachService]]
- [[Offline-First Strategy]]
- [[3+2 Mechanic]]
