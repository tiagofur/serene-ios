---
tags: [adr, architecture, ai, accepted]
adr_number: 002
status: accepted
date: 2026-04-14
---

# ADR-002 — Hybrid AI Architecture

## Status
**Accepted** · 2026-04-14

## Contexto
Necesitamos IA para:
- Coach response personalizada (alta calidad, baja latencia)
- Sentiment scoring (volumen alto, baja exigencia)
- Topic extraction (volumen alto, baja exigencia)
- Weekly summaries (calidad media-alta, frecuencia baja)
- Difficult mode chat (calidad alta, conversacional)

Coste de full-cloud sería prohibitivo (~$50/usuario/mes con 1000 Pro users).

## Decisión

**On-device para análisis estadísticos. Cloud para generación creativa.**

| Tarea | Dónde | Por qué |
|---|---|---|
| Sentiment scoring | `NLTagger` on-device | Suficiente, gratis |
| Topic extraction | Stop words + frequency | No necesita LLM |
| Coach response | Cloud (DeepSeek/Gemini) | Necesita matiz |
| Weekly summary | Cloud | Necesita prosa coherente |
| Difficult mode | Cloud | Conversación con contexto |
| Pattern stats | On-device | Statistics, no NLG |

Cada servicio cloud tiene **fallback local cálido** para offline.

## Consecuencias

### Positivas
- ✅ Coste IA <$15/mes con 1000 Pro users (vs $50+ full cloud)
- ✅ Latencia <100ms para sentiment (instant)
- ✅ Funciona 100% offline con calidad degradada pero usable
- ✅ Privacy: análisis sensible se queda en device
- ✅ Free tier puede recibir coach cloud (subsidiado) sin quemar margen

### Negativas
- ❌ Más complejidad: cada feature tiene 2 paths
- ❌ Fallback local debe mantenerse cálido (no robotic)
- ❌ Tests deben cubrir ambos paths
- ❌ Quality drift: cloud mejora con tiempo, local no

### Mitigations
- Fallbacks revisados en cada PR que toque IA
- Tests específicos para cada fallback
- Telemetría: track ratio cloud vs local per user

## Notas

### Apple Intelligence (iOS 18+)
En [[v2.0]] consideraremos Apple Intelligence APIs para:
- Resúmenes simples on-device
- Prompt rewriting
- Image generation para celebraciones

### Crisis Detection
**Tanto cloud como cliente** deben detectar señales de crisis. Es una salvaguarda crítica.

Ver [[AI Architecture]] sección Crisis Detection.

## 🔗 Relacionados
- [[AI Architecture]]
- [[AICoachService]]
- [[PatternDetectionService]]
- [[Cost Model]]
- [[ADR-005 - Natural Language for Sentiment]]
