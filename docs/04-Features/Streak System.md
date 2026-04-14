---
tags: [feature, gamification, streak]
status: completed
version_introduced: 1.0
extended: 1.1
tier: free
---

# Streak System

Sistema de racha con 3 capas: tracking, rescate, hitos.

## 📊 Visualización

### Streak Card en [[TodayView]]
Per [[StreakCardView]]:
- Icon flame en sage soft circle
- Número grande sage
- Label: "días de racha" (singular: "día")
- 7 dots representando la semana

### Week dots
| State | Color | Significado |
|---|---|---|
| `.done` | Sage fill | Día completado |
| `.today` | Arena fill | Hoy, pendiente |
| `.empty` | Border, sin fill | Día futuro o pasado vacío |

## 🔥 Lógica de tracking

[[StreakData]].recordEntry():
```
Si lastEntryDate == hoy → no-op (idempotente)
Si lastEntryDate == ayer → currentStreak += 1
Sino → currentStreak = 1 (reset)
```

Se actualiza `longestStreak` automáticamente.

## 💚 Rescate de racha (v1.1)

Per [[StreakRescueSheet]]:
- **1 rescate por mes calendario**
- Aplica si: usuario perdió ayer Y racha era ≥3
- UI: ofrece automáticamente al abrir TodayView en esos casos
- `rescuesUsedThisMonth` resetea con `checkMonthlyReset()`

Per PRD: _"Reduce frustracion. Los hábitos no se rompen por un día."_

## 🏆 Milestones (v1.1)

Per [[StreakMilestoneView]] — 7, 30, 100 días:

| Día | Emoji | Título | Mensaje |
|---|---|---|---|
| 7 | 🌱 | Una semana | "7 días seguidos. Algo está tomando raíz." |
| 30 | 🌳 | Un mes completo | "30 días contigo mismo. Esto ya no es una app." |
| 100 | ✨ | 100 días | "Has construido algo raro y valioso. Gracias." |

### Animación
Per PRD: _"no exagerada — no confetti explosion"_
- Icon scale 0.3→1 con spring
- Title slide-up 8px
- Subtitle slide-up 8px
- Botón "Gracias" después de 0.9s

### Push notification
Además del overlay in-app, [[SmartNotificationService]].sendMilestoneNotification dispara push para celebrar fuera de la app.

## 📬 Streak Protection (v1.1)

[[SmartNotificationService]].scheduleStreakProtection:
- Solo si racha ≥3
- Trigger: 22:00 si user no escribió hoy
- Interruption level: `.timeSensitive` (importante)
- Auto-cancela si user escribe antes

## 🎯 Reglas críticas

- ❌ NUNCA mostrar badges numéricos en tab bar
- ❌ NUNCA shame language ("perdiste tu racha")
- ✅ Lenguaje validador en pérdida ("Empezar de nuevo también es valioso")
- ✅ Rescate sin culpa: "Los hábitos no se rompen por un día"

## 🔗 Implementación

- Modelo: [[StreakData]]
- Views: [[StreakCardView]], [[StreakMilestoneView]], [[StreakRescueSheet]]
- Service: [[SmartNotificationService]]
- VM: [[TodayViewModel]] (rescue logic, milestone trigger)

## 🔗 Relacionados
- [[3+2 Mechanic]]
- [[Smart Notifications]]
- [[Streak Milestones]]
- [[Streak Rescue]]
