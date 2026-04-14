---
tags: [feature, ai, pro, insights]
status: completed
version_introduced: 1.2
tier: pro
---

# Pattern Detection

Análisis profundo de patrones emocionales en el historial. Pro feature.

## 🧪 3 análisis incluidos

### 1. Sentiment Series → [[Sentiment Chart]]
Serie temporal 30 días de tono emocional promedio diario.

### 2. Unexpected Connections → [[Unexpected Connections]]
Topics que correlacionan con sentiment más alto que baseline.

### 3. Language Evolution → [[Language Evolution]]
Cambio de vocabulario en últimos 30 días vs 30-60 días.

## 🤖 Implementación

100% on-device. Sin llamadas cloud. Ver [[PatternDetectionService]] para algoritmos detallados.

## 📊 Sentiment scoring

Cuando entry.sentimentScore es nil (caso típico offline o pre-analysis):
```swift
let tagger = NLTagger(tagSchemes: [.sentimentScore])
tagger.string = text
let raw = sentiment.rawValue  // [-1, 1]
return (raw + 1) / 2          // → [0, 1]
```

Ver [[ADR-005 - Natural Language for Sentiment]].

## 🎨 Vistas

| Análisis | View |
|---|---|
| Sentiment series | [[SentimentChartView]] (Swift Charts) |
| Connections | [[ConnectionsView]] (cards con narrativa) |
| Language | [[LanguageEvolutionView]] (word clouds con FlowLayout) |

Todas integradas en [[InsightsView]] cuando user es Pro.

## 📋 Requisitos de datos

| Análisis | Mínimo entries |
|---|---|
| Sentiment series | 1+ por día queryeable |
| Connections | ≥10 entries en 30 días |
| Language evolution | ≥1 en cada window de 30 días |

Si faltan datos, vista muestra placeholder amable: _"Sigue escribiendo y aparecerá tu tendencia."_

## 🔄 Refresh

`InsightsView.loadProInsights()`:
- Una vez al cargar la vista (`.task`)
- Cada vez que cambia `recentGratitudes.count`

## 💾 Persistencia

Connections detectadas se snapshotean como [[PatternEntry]] (type=`connection`) para permitir consulta histórica. Las más recientes reemplazan a las anteriores.

## 🔗 Relacionados
- [[PatternDetectionService]]
- [[Sentiment Chart]]
- [[Unexpected Connections]]
- [[Language Evolution]]
- [[Monetization Model]]
- [[v1.2]]
