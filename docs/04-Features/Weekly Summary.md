---
tags: [feature, ai, insights]
status: completed
version_introduced: 1.1
tier: free + pro
---

# Weekly Summary

Resumen narrativo semanal generado por el coach. Free tier 1/mes, Pro ilimitado.

## 🎯 Comportamiento

- **Auto-generación los lunes** en `InsightsView.task`
- Free: **máximo 1 resumen/mes** (sample para demo de valor)
- Pro: **un resumen cada lunes**
- Necesita ≥3 gratitudes en la semana

## 📜 Estructura

```
Esta semana, [Nombre], tu mente estuvo en dos lugares:
[topic1] y [topic2].

[Frase de tendencia según sentiment]

Escribiste [N] momentos de gratitud — cada uno una pequeña semilla. 🌱
```

### Frases de tendencia
- `ascending`: "Tu semana tuvo un tono luminoso — algo estaba creciendo dentro."
- `reflective`: "Notaste momentos más introspectivos esta semana, y eso también tiene su belleza."
- `stable`: "Mantuviste un ritmo suave, presente, constante."

## 📊 Análisis incluido

Por [[WeeklySummaryService]]:
- **Top 3 topics** (extracción on-device)
- **Dominant emoji** (más usado en entries)
- **Sentiment trend** (ascending / stable / reflective)
- **Narrativa** (cloud o local fallback)

## 🎨 UI

### Card en [[InsightsView]]
- Icon `text.bubble`
- Header "RESUMEN SEMANAL"
- Dominant emoji 24pt
- Narrativa lineLimit(4)
- Topic pills sage soft
- "Ver completo" → opens detail

### Detail view
[[WeeklySummaryDetailView]]:
- Shareable card con design completo
- Lista de temas con números
- Botón "Compartir resumen" → genera imagen 3x via `ImageRenderer` y abre `UIActivityViewController`

## 📤 Compartir como imagen

```swift
let renderer = ImageRenderer(content: shareableCard.frame(width: 340)...)
renderer.scale = 3.0
let uiImage = renderer.uiImage
ShareSheet(items: [uiImage])
```

Per PRD: _"Compartir como imagen (opcional, nunca forzado)"_

## 🔗 Implementación

- Modelo: [[WeeklySummaryEntry]]
- Service: [[WeeklySummaryService]]
- Views: [[InsightsView]] + [[WeeklySummaryDetailView]]

## 🔗 Relacionados
- [[AI Coach]]
- [[Pattern Detection]]
- [[Monetization Model]]
- [[v1.1]]
