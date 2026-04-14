---
tags: [model, code]
file: Serene/Models/StreakData.swift
---

# StreakData

Singleton del usuario para tracking de racha.

## Schema

```swift
@Model
final class StreakData {
    var id: UUID
    var currentStreak: Int
    var longestStreak: Int
    var lastEntryDate: Date?
    var rescuesUsedThisMonth: Int
    var lastRescueDate: Date?
}
```

## API

### `recordEntry()`
Idempotente. Llamado al completar 3/3 hoy.

```swift
let today = startOfDay(today)
let yesterday = startOfDay(today - 1)

if lastEntryDate == today { return }    // No-op
if lastEntryDate == yesterday {
    currentStreak += 1
} else {
    currentStreak = 1                    // Reset
}

lastEntryDate = today
longestStreak = max(longestStreak, currentStreak)
```

### `useRescue() -> Bool`
Pro o free. Solo si `canRescue == true`.

```swift
guard canRescue else { return false }
rescuesUsedThisMonth += 1
lastRescueDate = Date()
if currentStreak == 0 { currentStreak = 1 }
lastEntryDate = Date()
return true
```

### `checkMonthlyReset()`
Llamado en cada `loadTodayData`. Resetea contador si cambió mes.

```swift
guard let lastRescue = lastRescueDate else { return }
if !calendar.isDate(lastRescue, equalTo: Date(), toGranularity: .month) {
    rescuesUsedThisMonth = 0
}
```

### `canRescue: Bool` (computed)
```swift
rescuesUsedThisMonth < 1
```

## Pattern

Singleton: solo una instancia por device.

```swift
let descriptor = FetchDescriptor<StreakData>()
if let existing = try? context.fetch(descriptor).first {
    existing.checkMonthlyReset()
    return existing
} else {
    let new = StreakData()
    context.insert(new)
    return new
}
```

## 🔗 Relacionados
- [[Streak System]]
- [[Streak Rescue]]
- [[TodayViewModel]]
- [[Data Models]]
