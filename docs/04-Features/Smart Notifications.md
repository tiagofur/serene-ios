---
tags: [feature, notifications, smart]
status: completed
version_introduced: 1.1
tier: free
---

# Smart Notifications

Notificaciones que aprenden del comportamiento del usuario.

## 🧠 Cómo aprende

[[SmartNotificationService]].detectHabitualHour:
1. Lee últimos **14 días** de gratitudes
2. Necesita **mínimo 5 entries**
3. Cuenta hour-of-day más frecuente
4. Programa nudge **15 min antes** de esa hora

## 📬 Tipos de notificaciones

### 1. Smart Nudge (passive)
- Hora habitual −15min
- Calendar trigger, repeats daily
- Interruption level: `.passive` (no rompe foco)
- Variantes copy:
  > _"Tu momento se acerca, María. ¿Algo bueno del día? 🌿"_
  > _"Hola María, tu coach te espera en unos minutos. ✨"_
  > _"María, un pequeño ritual te está esperando. 🙏"_

### 2. Streak Protection (timeSensitive)
- 22:00 si racha ≥3 y no escribió hoy
- One-shot, auto-cancel si user escribe
- Interruption level: `.timeSensitive` (importante)
- Copy:
  > _"María, tu racha de 12 días te está esperando. Un momento es suficiente. 🔥"_

### 3. Milestone Push
- Trigger inmediato al alcanzar 7/30/100
- Copy específico por hito (ver [[Streak Milestones]])

## 🔄 Lifecycle

```
User completa 3/3 hoy
    ↓
SmartNotificationService.cancelStreakProtection()    ← libera el slot 22:00
SmartNotificationService.scheduleSmartNudge(...)     ← refresh nudge timing
if streak >= 3:
    SmartNotificationService.scheduleStreakProtection(...) ← para mañana noche
if milestone:
    SmartNotificationService.sendMilestoneNotification(...) ← inmediata
```

## 🆚 Vs NotificationService (básico)

| Feature | NotificationService | SmartNotificationService |
|---|---|---|
| Hora | Fija (configurada) | Aprendida |
| Timing | Hora exacta | 15 min antes |
| Interruption | default | passive (nudge) o timeSensitive (protection) |
| Streak aware | ❌ | ✅ |
| Milestone push | ❌ | ✅ |

Ambos coexisten — el primero es para configuración manual del usuario, el segundo es proactivo.

## 📏 Reglas críticas

- ❌ Nunca crear ansiedad ("¡Estás abandonando!")
- ❌ Nunca more than 2 notifications/day
- ✅ Cada notificación debe sentirse como un **gentle nudge**
- ✅ Auto-cancel cuando ya no son relevantes

## 🔗 Implementación

- Service: [[SmartNotificationService]]
- Trigger: [[TodayViewModel]] llama después de completar 3/3
- Permission: pedido en [[ReminderStepView]] (onboarding paso 5)

## 🔗 Relacionados
- [[NotificationService]]
- [[Streak System]]
- [[v1.1]]
