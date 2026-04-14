---
tags: [feature, insights]
status: completed
version_introduced: 1.0
tier: free
---

# Activity Calendar

Calendario tipo GitHub contributions, 30 días.

## 🎨 Visual

7 columnas × ~5 filas con cuadrados redondeados.

| Cant. entries | Color |
|---|---|
| 0 | Surface (gris claro) |
| 1-2 | Sage soft |
| 3-4 | Sage 60% opacity |
| 5+ | Sage solid |

Legend abajo: "Menos [4 squares scale] Más"

## 🔗 Implementación

`InsightsView.activityCalendar` usa `LazyVGrid` con 10 columnas y `gratitudeCount(for: date)` para color.

## 🔗 Relacionados
- [[Insights View]]
- [[Pattern Detection]]
