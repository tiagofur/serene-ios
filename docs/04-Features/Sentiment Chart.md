---
tags: [feature, pro, insights, chart]
status: completed
version_introduced: 1.2
tier: pro
---

# Sentiment Chart

Gráfica suave de tono emocional 30 días. Per PRD §3.5: _"no fría, no estilo analytics"_.

## 🎨 Visual

- Línea sage 2.5px con `interpolationMethod(.catmullRom)`
- Área degradada sage 25% → 2% bottom
- Y-axis: 0 a 1, tres gridlines suaves
- X-axis: marcas cada 7 días formato `dd`
- Caption descriptivo según tendencia

## 📝 Caption logic

```
Compara avg primera mitad vs segunda mitad
Diff >= 0.08:    "Tu tono se ha iluminado en las últimas semanas."
Diff <= -0.08:   "Has notado momentos más reflexivos recientemente — eso también cuenta."
Otro:            "Mantienes un tono emocional estable y presente."
```

## 🔧 Implementación

[[SentimentChartView]] usa Swift Charts (`Chart` + `LineMark` + `AreaMark`).

Datos provienen de [[PatternDetectionService]].sentimentSeries — agregación diaria de scores.

## 📊 Estado

Si `points.count < 3` → empty state con icon `waveform.path` y mensaje amable.

## 🔗 Relacionados
- [[Pattern Detection]]
- [[PatternDetectionService]]
- [[ADR-005 - Natural Language for Sentiment]]
- [[v1.2]]
