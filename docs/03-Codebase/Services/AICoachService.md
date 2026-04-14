---
tags: [service, code, ai, coach]
file: Serene/Services/AICoachService.swift
---

# AICoachService

Genera respuestas del coach. Cloud + local fallback cálido.

## Responsabilidades
- Pedir al backend coach response personalizada
- Caer a respuestas locales pre-escritas si offline
- Generar weekly summary narratives (helper, llamado por [[WeeklySummaryService]])

## API Pública

```swift
final class AICoachService {
    static let shared: AICoachService

    func getCoachResponse(
        gratitudeText: String,
        emoji: String,
        userName: String,
        previousGratitudes: [String] = []
    ) async -> String

    func getWeeklySummary(
        gratitudes: [String],
        userName: String
    ) async -> String?
}
```

## Local Fallback

7 plantillas warm con `\(userName)` interpolado. Random selection.

Ejemplos:
- _"Qué bonito que notes eso, María. Los pequeños momentos son los que más cuentan. 🌿"_
- _"Me encanta que hayas parado a agradecer eso, María. Es una señal de que estás presente. ✨"_
- _"María, la gratitud que sientes ahora es real y valiosa. Guárdala en tu corazón. 🙏"_

### Reglas para fallbacks
- Siempre incluir `userName`
- Máximo 2 frases
- Tono validador, no consejos
- Emoji al final (sage / sparkle / leaf / etc)
- Nunca dirigir a recursos médicos en fallback (eso lo hace cloud)

## Flujo cuando se llama

```
await getCoachResponse(text, emoji, userName, previous)
    │
    ├── try POST /ai/coach
    │   └── decode CoachResponse → return
    │
    └── catch → return generateLocalResponse(text, userName)
```

## Roadmap

- [[v2.0]]: Apple Intelligence on-device para resúmenes simples
- Pendiente: track ratio cloud-vs-local per user para telemetría calidad
- Pendiente: más variantes de fallback (15-20)

## ⚠️ Crisis Detection

⚠️ **TODO**: Implementar detection de keywords en `gratitudeText` antes de llamar:
- "no quiero", "ya no puedo", "no vale la pena", etc
- Si match → respuesta especial con recursos profesionales
- Override tanto cloud como local

Ver [[AI Architecture]] sección Crisis Detection.

## Tests pendientes
- [ ] Cloud success → cloud response
- [ ] Cloud failure → local fallback ≠ empty
- [ ] Crisis keywords detection (TODO)

## 🔗 Relacionados
- [[AI Architecture]]
- [[AI Coach]]
- [[ADR-002 - Hybrid AI Architecture]]
- [[GratitudeService]]
