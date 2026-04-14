---
tags: [feature, gamification, milestones]
status: completed
version_introduced: 1.1
tier: free
---

# Streak Milestones

Celebración de hitos a 7, 30 y 100 días.

## 🏆 Hitos

| Día | Emoji | Título | Mensaje |
|---|---|---|---|
| 7 | 🌱 | Una semana | "7 días seguidos. Algo está tomando raíz — y eso no es poca cosa." |
| 30 | 🌳 | Un mes completo | "30 días contigo mismo. Esto ya no es una app: es tu hábito." |
| 100 | ✨ | 100 días | "Has construido algo raro y valioso. Gracias por confiar." |

## 🎬 Animación

Per PRD: _"no exagerada — no confetti explosion"_

[[StreakMilestoneView]] runAnimationSequence:
- t=0: showIcon spring 0.5 / damping 0.65 (scale 0.3 → 1.0)
- t=300: showTitle ease 0.4 (offset 8 → 0)
- t=500: showSubtitle ease 0.4
- t=900: showButton ease 0.3

Botón: "Gracias" (no "OK", no "Continue")

## 🔁 Trigger

[[TodayViewModel]].saveGratitude detecta:
```swift
if completedBaseCount == 3 && !extrasUnlocked {
    streakData?.recordEntry()
    let milestone = milestoneForStreak(currentStreak)
    if let m = milestone {
        // After main celebration finishes
        await sleep(2s)
        showMilestone = true
        SmartNotificationService.sendMilestoneNotification(...)
    }
}
```

## 📬 Notificación push

Además del overlay in-app, se envía push notification (interval 1s, single-shot) para celebrar fuera de la app.

Ver [[SmartNotificationService]].sendMilestoneNotification.

## 🔗 Relacionados
- [[Streak System]]
- [[StreakMilestoneView]]
- [[SmartNotificationService]]
- [[v1.1]]
