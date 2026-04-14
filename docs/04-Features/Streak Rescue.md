---
tags: [feature, gamification, rescue]
status: completed
version_introduced: 1.1
tier: free
---

# Streak Rescue

Recupera tu racha perdida — 1 vez por mes.

## 🎯 Por qué existe

Per PRD: _"Reduce frustracion. Los hábitos no se rompen por un día."_

## 📋 Reglas

- **Limit**: 1 rescate por mes calendario
- **Reset**: automático cuando cambia el mes
- **Eligibility**: usuario perdió ayer Y racha era ≥3
- **Effect**: restaura `currentStreak`, marca `lastEntryDate = hoy`

## 🎨 UI

[[StreakRescueSheet]]:
- Icon heart rosa en círculo soft
- Title "Recupera tu racha"
- Body adaptativo:
  - Si puede rescatar: "Los hábitos no se rompen por un día. Puedes rescatar tu racha de N días — una vez al mes."
  - Si ya usó este mes: "Ya usaste tu rescate este mes. Tranquilo: empezar de nuevo también es valioso."
- CTA "Rescatar mi racha" (si elegible)
- CTA secundario "Mejor empiezo de nuevo" / "Entendido"

## 🔄 Flujo

```
User abre TodayView
    ↓
TodayViewModel.shouldOfferRescue() check:
    last < yesterday.startOfDay
    && last >= dayBeforeYesterday.startOfDay
    && currentStreak >= 3
    && canRescue
    ↓ [si true]
DispatchQueue.main.asyncAfter(0.8) {
    showRescueSheet = true
}
```

## 💾 Persistencia

[[StreakData]]:
- `rescuesUsedThisMonth: Int`
- `lastRescueDate: Date?`
- `func useRescue() -> Bool`
- `func checkMonthlyReset()` — llamado en `loadTodayData`

## 📊 Visible en Profile

[[ProfileView]] muestra contador "Rescates de racha: 1/1" o "0/1" según uso.

## 🔗 Relacionados
- [[Streak System]]
- [[StreakRescueSheet]]
- [[StreakData]]
- [[v1.1]]
