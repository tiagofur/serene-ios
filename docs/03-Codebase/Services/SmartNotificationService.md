---
tags: [service, code, notifications, smart]
file: Serene/Services/SmartNotificationService.swift
version_introduced: 1.1
---

# SmartNotificationService

Notificaciones que aprenden del usuario. Per PRD §3.3.

## Responsabilidades
- Detectar hora habitual del usuario de últimas 14 días
- Programar **nudge soft 15 min antes** de esa hora
- Programar **streak protection** a las 22:00 si no escribió y tiene racha
- Enviar **milestone push** al alcanzar 7/30/100 días

## API Pública

```swift
final class SmartNotificationService {
    static let shared: SmartNotificationService

    @MainActor
    func detectHabitualHour(context: ModelContext, lookbackDays: Int = 14) -> Int?

    @MainActor
    func scheduleSmartNudge(userName: String, context: ModelContext)

    func scheduleStreakProtection(userName: String, currentStreak: Int)
    func cancelStreakProtection()

    func sendMilestoneNotification(streak: Int, userName: String)
}
```

## Identifiers

| ID | Tipo | Trigger |
|---|---|---|
| `smart_nudge_reminder` | Smart nudge | Calendar repeats, hora habitual −15min |
| `streak_protection` | One-shot | Calendar 22:00, sólo si racha ≥3 |
| `milestone_<N>` | One-shot | TimeInterval 1s |

## Detection logic

```swift
let entries = fetchLast14Days(context)
guard entries.count >= 5 else { return nil }
let hours = entries.map { Calendar.current.component(.hour, from: $0.createdAt) }
let counts = Dictionary(grouping: hours, by: { $0 }).mapValues(\.count)
return counts.max { $0.value < $1.value }?.key
```

Necesita **mínimo 5 entries** para detectar patrón.

## Interruption levels

- Smart nudge: `.passive` — no rompe foco
- Streak protection: `.timeSensitive` — si racha está en peligro, sí queremos atención
- Milestone: default — celebración

## Cuándo se ejecuta

- `scheduleSmartNudge` después de cada save con 3/3 completado
- `scheduleStreakProtection` después de cada 3/3 si racha ≥3
- `cancelStreakProtection` en `loadTodayData` cuando user ya escribió hoy
- `sendMilestoneNotification` cuando `streak ∈ {7, 30, 100}`

## ⚠️ Limitaciones

- ❌ No considera fines de semana vs entresemana (mismo time)
- ❌ No considera días específicos (algunos usuarios escriben sólo lunes)
- ❌ Requiere 5 entries para activar (~1 semana de uso)

## Roadmap

- [[v2.0]]: Considerar día de la semana (mejor patrón)
- [[v2.0]]: Batch entries por hora con ventana ±30min para suavizar

## 🔗 Relacionados
- [[Smart Notifications]]
- [[Streak System]]
- [[Streak Milestones]]
- [[v1.1]]
