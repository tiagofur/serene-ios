---
tags: [service, code, ai, patterns]
file: Serene/Services/PatternDetectionService.swift
version_introduced: 1.2
---

# PatternDetectionService

Análisis de patrones emocionales. 100% on-device.

## Responsabilidades
- Detectar [[Unexpected Connections]] (topics que mejoran sentiment)
- Calcular [[Language Evolution]] (60d vs 30d word changes)
- Generar [[Sentiment Chart]] series
- Snapshotear connections como [[PatternEntry]] persistente

## API Pública

```swift
@MainActor
final class PatternDetectionService {
    static let shared: PatternDetectionService

    func detectConnections(context: ModelContext, limit: Int = 3) -> [EmotionalConnection]

    func analyzeLanguageEvolution(context: ModelContext) -> LanguageEvolution?

    func sentimentSeries(context: ModelContext, days: Int = 30) -> [SentimentPoint]

    func snapshotConnections(_ connections: [EmotionalConnection], context: ModelContext)
}
```

## Modelos de retorno

### `EmotionalConnection`
```swift
struct EmotionalConnection: Identifiable {
    let id: UUID
    let topic: String              // "Naturaleza"
    let sentimentLift: Double      // 0.18
    let occurrences: Int
    var narrative: String          // "Cuando mencionas naturaleza, tu tono es..."
}
```

### `LanguageEvolution`
```swift
struct LanguageEvolution {
    let previousPeriodTopWords: [String]
    let currentPeriodTopWords: [String]
    let newWords: [String]         // En current pero no en previous
    let fadingWords: [String]      // En previous, casi no en current
    let expansionCount: Int        // Cantidad de palabras nuevas únicas
}
```

### `SentimentPoint`
```swift
struct SentimentPoint: Identifiable {
    let id: UUID
    let date: Date                  // Día (startOfDay)
    let value: Double               // [0, 1]
    let entryCount: Int
}
```

## Algoritmos

### Connections
1. Calcular `baseline` = promedio sentiment de últimos 30 días
2. Para cada palabra recurrente (≥3 ocurrencias):
   - Calcular `avgSentiment` de entries que contienen esa palabra
   - `lift = avgSentiment - baseline`
3. Filtrar `lift >= 0.08` (umbral significancia)
4. Sort por lift, top 3

### Language Evolution
1. Window 1: últimos 30 días → `currentCounts`
2. Window 2: 60-30 días atrás → `previousCounts`
3. `newWords` = en current ≥2 ocurrencias, en previous ≤1
4. `fadingWords` = en previous ≥3, en current ≤1
5. `expansionCount` = `currentSet.subtract(previousSet).count`

### Sentiment series
1. Group entries by `startOfDay`
2. Para cada día: avg de `sentimentScore ?? NLTagger(text)`
3. Devolver `SentimentPoint` ordenados

### Sentiment fallback (NLTagger)
```swift
let tagger = NLTagger(tagSchemes: [.sentimentScore])
tagger.string = text
let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
let raw = Double(sentiment?.rawValue ?? "0") ?? 0
return (raw + 1) / 2  // Normalize [-1,1] → [0,1]
```

Ver [[ADR-005 - Natural Language for Sentiment]].

## Stop words

Compartidas con [[WeeklySummaryService]] (idealmente extraer a `Constants`).

```swift
["hoy", "agradezco", "por", "que", "una", "uno", "del", "los", "las",
 "con", "para", "como", "más", "muy", "fue", "ser", "este", "esta",
 "eso", "esa", "tengo", "estar", "también", "había", "pero", "sobre",
 "entre", "cuando", "donde", "porque", "estoy", "siento", "puedo",
 "quiero", "tener", "hacer", "sido", "estaba"]
```

## Cuándo se llama

`InsightsView.loadProInsights()`:
- En `.task` inicial
- En `onChange(of: recentGratitudes.count)` para refresh

## ⚠️ Limitaciones

- ❌ Stop words ES-only
- ❌ No lemmatización (familia / familias = palabras distintas)
- ❌ No considera negaciones ("no agradezco la lluvia")
- ❌ Necesita ≥10 entries para connections, ≥1 entry en cada window de 30 días para evolution

## 🔗 Relacionados
- [[Pattern Detection]]
- [[Unexpected Connections]]
- [[Language Evolution]]
- [[Sentiment Chart]]
- [[ADR-005 - Natural Language for Sentiment]]
- [[v1.2]]
