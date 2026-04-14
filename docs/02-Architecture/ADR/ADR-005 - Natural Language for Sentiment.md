---
tags: [adr, architecture, ai, accepted]
adr_number: 005
status: accepted
date: 2026-04-14
---

# ADR-005 — NaturalLanguage Framework para Sentiment

## Status
**Accepted** · 2026-04-14

## Contexto
Para [[Pattern Detection]] necesitamos sentiment scores en cada `GratitudeEntry`. Opciones:
1. **Cloud LLM**: Pedir score al modelo cuando se llama coach
2. **NaturalLanguage framework**: `NLTagger` con `.sentimentScore`
3. **Core ML custom model**: Entrenar uno propio
4. **VADER o similar**: Library third-party

## Decisión

Usar **`NaturalLanguage.NLTagger` con `.sentimentScore`** scheme on-device.

```swift
let tagger = NLTagger(tagSchemes: [.sentimentScore])
tagger.string = text
let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
// sentiment.rawValue → Double in [-1, 1]
```

## Consecuencias

### Positivas
- ✅ Free, instant, on-device
- ✅ Apple-mantained, mejora con cada iOS
- ✅ Funciona en español sin config extra
- ✅ Privacy: nunca sale el texto del device para sentiment
- ✅ Sin dependencia externa

### Negativas
- ❌ Calidad: ~70-80% accuracy vs LLM (~90%+)
- ❌ Sensible a sarcasmo, ironía
- ❌ No considera contexto cross-entry
- ❌ Range a veces clipped (mucho `0.0`)

### Mitigations
- Cuando hay score cloud (`entry.sentimentScore`), preferirlo sobre on-device
- Para gráficas usamos promedio diario (suaviza outliers)
- Default a 0.55 (slight positive) si scoring falla — los gratitudes son inherentemente positivos

## Alternativas consideradas

### Cloud LLM con prompt explícito
```
"Score this gratitude 0-1 for emotional positivity: ..."
```
- ✅ Mejor calidad
- ❌ +1 round-trip por entry → latencia o batch
- ❌ Coste extra si batchear

**Veredicto**: Reservar para futuro reanalysis batch (background task mensual).

### Core ML custom
- ✅ Fine-tuned para nuestro dominio
- ❌ Necesita training data labeleada
- ❌ Mantenimiento propio

**Veredicto**: Considerar en [[v2.1]] cuando tengamos volumen.

### VADER
- ❌ No funciona bien en español sin port
- ❌ Dependencia externa

## Notas

### Migration path
Si en futuro queremos LLM scoring:
1. Mantener `sentimentScore` campo
2. Background task batch-procesa entries con `sentimentScore == nil`
3. Persistir nuevos scores
4. PatternDetectionService prefiere cloud score si existe

## 🔗 Relacionados
- [[PatternDetectionService]]
- [[AI Architecture]]
- [[Sentiment Chart]]
- [[ADR-002 - Hybrid AI Architecture]]
