---
tags: [feature, core, mechanic]
status: completed
version_introduced: 1.0
tier: free
---

# 3+2 Mechanic

> El **corazón** del producto. 3 gratitudes base diarias + 2 extras desbloqueables.

## 🎯 Cómo funciona

| Slot | Prompt | Tipo | Cuándo aparece |
|---|---|---|---|
| Gratitud 1 | "Hoy agradezco..." | Base | Siempre |
| Gratitud 2 | "Hoy agradezco..." | Base | Siempre |
| Gratitud 3 | "Hoy agradezco..." | Base | Siempre |
| Extra 1 | "¿Qué te sorprendió hoy?" | Reflexivo | Tras completar 3 base |
| Extra 2 | "¿A quién agradeces y no se lo has dicho?" | Relacional | Tras completar 3 base |

## 🧠 Diseño psicológico

### Por qué 3+2 (y no 5)
- **3 base = meta minima**: Sentido de logro al completar
- **2 extras = recompensa**: La sensación de "unlock" activa dopamina
- Investigación de **Emmons & McCullough**: 3-5 gratitudes/día es óptimo

### Por qué los extras NO son obligatorios
- El usuario que solo hace 3 se va satisfecho ✅
- El usuario que llega a 5 se va con mayor reflexión + logro 🌟
- Los extras NUNCA generan culpa de "no completaste"
- En lugar de "Skip" decimos "Por hoy es suficiente"

## 🎨 Estados visuales del slot

Ver [[GratitudeSlotView]] enum `GratitudeSlotState`:

| Estado | Visual |
|---|---|
| `.empty` | Border dashed, prompt en gris terciario |
| `.active` | Border sage 1.5px (siguiente a completar) |
| `.done` | Surface fill, check sage, texto + coach reply |
| `.extraLocked` | Lock icon, "Completa tus 3 para desbloquear" |
| `.extraUnlocked` | Border arena 1.5px, tag "EXTRA" en pill arena |

## 🎬 Flujo de unlock

```
User completa gratitud 3
    ↓
TodayViewModel.completedBaseCount == 3
    ↓
streakData.recordEntry()  ← +1 a racha
    ↓
[delay 500ms]
    ↓
withAnimation: showCelebration = true
    ↓
[CelebrationOverlayView aparece con animación secuenciada]
    ↓
extrasUnlocked = true
    ↓
TodayView muestra extrasSection con 2 slots arena
```

Ver [[CelebrationOverlayView]] para detalle de animación.

## 🔗 Implementación

- Modelo: [[GratitudeEntry]] con `slotIndex: Int` y `isExtra: Bool`
- VM: [[TodayViewModel]] (`completedBaseCount`, `extrasUnlocked`)
- Views: [[GratitudeSlotView]], [[CelebrationOverlayView]]
- Service: [[GratitudeService]]

## 📏 Reglas de diseño

- ❌ Nunca mostrar "5 de 5" (presión cuantitativa)
- ❌ Nunca mostrar progress bar de gratitudes
- ✅ Sí mostrar checks individuales por slot
- ✅ Tono de los prompts: invitación, no orden

## 🔗 Relacionados
- [[Vision]]
- [[AI Coach]]
- [[Streak System]]
- [[CelebrationOverlayView]]
- [[GratitudeSlotView]]
