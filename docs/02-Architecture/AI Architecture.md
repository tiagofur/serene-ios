---
tags: [architecture, ai]
updated: 2026-04-14
---

# AI Architecture

Estrategia híbrida on-device + cloud. Maximiza calidad emocional vs control de costes.

## 🎯 Principio

> **On-device para lo cuantitativo. Cloud para lo cualitativo.**

| Necesidad | Dónde | Por qué |
|---|---|---|
| Sentiment scoring | On-device (`NLTagger`) | Suficientemente bueno, gratis, instant |
| Topic extraction | On-device (regex + stop words) | No necesita LLM |
| Coach response post-gratitud | Cloud (DeepSeek V3 / Gemini Flash) | Necesita personalización profunda |
| Weekly summary narrative | Cloud | Necesita coherencia en prosa |
| Difficult mode chat | Cloud | Conversacional, contexto largo |
| Pattern connections | On-device (statistics) | No necesita LLM |
| Language evolution | On-device | Frequency analysis |

## 🤖 Servicios cloud

### Modelos preferidos
1. **DeepSeek V3** — Calidad alta, coste bajo (~$0.14/M tokens input)
2. **Gemini Flash 2.0** — Alternativa con free tier generoso

### Cuándo se llama
- ✅ Cada `POST /gratitudes` (free + pro) — coach response inline
- ✅ Lunes de cada semana — weekly summary
- ✅ Cada turno de difficult mode — chat
- ❌ Nunca para sentiment puro (es on-device)
- ❌ Nunca para topic extraction (es on-device)

### System prompt principios

> _"Eres un coach cálido, no clínico. Validas antes de sugerir. Usas el nombre del usuario. Respondes en máximo 2 frases. Nunca das consejos médicos. Detectas señales de crisis y rediriges a recursos profesionales."_

(El prompt completo vive en backend Go)

## 📱 Servicios on-device

### NaturalLanguage framework

```swift
let tagger = NLTagger(tagSchemes: [.sentimentScore])
tagger.string = text
let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
// sentiment.rawValue → Double in [-1, 1]
```

Normalizamos a `[0, 1]` para gráficas.

### Apple Intelligence (futuro)
A partir de iOS 18+:
- `WritingTools` para sugerir reformulaciones
- Local LLM para resúmenes simples
- Image Playground para celebraciones visuales

⚠️ **TODO** [[v2.0]]: Adoptar Apple Intelligence APIs cuando estabilicen.

## 💰 Cost Model

### Por usuario Pro/semana
- 5 gratitudes × 7 días = 35 coach responses → ~70K input tokens, ~10K output → **$0.012**
- 1 weekly summary → ~5K input, 500 output → **$0.001**
- ~5 difficult mode turns → ~10K input, 2K output → **$0.002**
- **Total: ~$0.015/usuario Pro/semana**

### Escalabilidad
- 100 Pro users → ~$6/mes
- 1,000 Pro users → ~$60/mes
- 10,000 Pro users → ~$600/mes

**Con ARPU $4.50, márgenes >85% en IA.**

### Free tier
- Recibe coach response cloud al guardar (parte del valor inicial)
- 1 weekly summary/mes
- Sin difficult mode
- **Coste estimado: ~$0.005/usuario free/semana** (subsidiado para conversión)

## 🛡️ Crisis Detection

⚠️ **TODO**: Implementar keyword detection en cliente para:
- Suicide ideation
- Self-harm
- Severe depression markers

Cuando se detecta, reemplazar respuesta normal con:
1. Validación
2. Reconocimiento de gravedad
3. Recursos: línea de crisis país-específico
4. Sugerencia de hablar con profesional

Esto debe vivir tanto en prompt cloud como en cliente como safety net.

## 🔒 Privacidad

- Solo se envía: `text`, `emoji`, `userName` (no email, no IP en payload)
- No se almacenan logs de prompts en servidor más allá de 7 días
- Usuario puede deshabilitar AI cloud → solo on-device (futuro setting)

## 🔗 Relacionados
- [[AICoachService]]
- [[DifficultModeService]]
- [[WeeklySummaryService]]
- [[PatternDetectionService]]
- [[ADR-002 - Hybrid AI Architecture]]
- [[ADR-005 - Natural Language for Sentiment]]
- [[Cost Model]]
