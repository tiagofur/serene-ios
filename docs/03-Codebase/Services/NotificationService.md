---
tags: [service, code, notifications]
file: Serene/Services/NotificationService.swift
---

# NotificationService

Notificaciones básicas (recordatorio diario). Para lógica avanzada ver [[SmartNotificationService]].

## Responsabilidades
- Pedir permiso de notificaciones
- Programar recordatorio diario en hora fija configurada
- Cancelar todos los recordatorios

## API Pública

```swift
final class NotificationService {
    static let shared: NotificationService

    func requestPermission() async -> Bool

    func scheduleDailyReminder(at time: Date, userName: String)

    func cancelAllReminders()
}
```

## Identifiers usados

| ID | Descripción | Trigger |
|---|---|---|
| `daily_gratitude_reminder` | Reminder diario en hora elegida | `UNCalendarNotificationTrigger` repeats |

## Variantes de copy

4 plantillas randomized con `userName`:
- _"María, hoy es un buen día para agradecer. ¿Qué te hizo sonreír? 🌿"_
- _"Oye María, ¿un momento para ti? Tu ritual de gratitud te espera. ✨"_
- _"María, 3 pequeños agradecimientos pueden cambiar tu día. ¿Vamos? 🙏"_
- _"Tu momento de calma te espera, María. ¿Qué fue bueno hoy? 🍃"_

## Permission flow

```swift
let granted = try await UNUserNotificationCenter.current()
    .requestAuthorization(options: [.alert, .sound])
```

Si denied: app sigue funcionando, sólo no notifica. Nunca insistir.

## 🔗 Relacionados
- [[SmartNotificationService]]
- [[Daily Reminder]]
- [[Onboarding Flow]] (paso 5 pide permission)
