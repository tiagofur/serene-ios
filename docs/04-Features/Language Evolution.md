---
tags: [feature, pro, insights]
status: completed
version_introduced: 1.2
tier: pro
---

# Language Evolution

> Per PRD §3.5: _"Comparacion de palabras usadas hace 30 dias vs ahora"_

## 🎯 Qué es

Compara tu vocabulario en los **últimos 30 días** vs los **30-60 días anteriores**. Identifica palabras que aparecieron, desaparecieron, y cuánto se expandió tu lenguaje emocional.

## 📊 Algoritmo

Per [[PatternDetectionService]].analyzeLanguageEvolution:

```
window1 (current) = entries en [now-30d, now]
window2 (previous) = entries en [now-60d, now-30d]

countsCurrent = wordFrequency(window1)
countsPrevious = wordFrequency(window2)

newWords =
  palabras en current con ≥2 ocurrencias
  donde previous tiene ≤1

fadingWords =
  palabras en previous con ≥3 ocurrencias
  donde current tiene ≤1

expansionCount =
  |currentWords - previousWords|
```

## 🎨 UI

[[LanguageEvolutionView]] con FlowLayout custom:
- Section "Palabras que aparecieron" — pills sage
- Section "Palabras que se fueron" — pills earth tone
- Footer: "Vocabulario expandido +N palabras" en sage

### FlowLayout
Implementación custom de `Layout` protocol que envuelve children como flexbox. Necesario porque SwiftUI no tiene built-in.

## ⚠️ Necesita ≥1 entry en cada window

Si falta: placeholder _"Necesitamos 60 días de entradas para comparar tu lenguaje. Sigue escribiendo."_

## 💡 Insight semántico

El cambio de palabras refleja:
- Crecimiento emocional ("ansiedad" → "calma")
- Cambios de vida ("trabajo" → "proyecto", "soledad" → "amigos")
- Estaciones internas ("agotamiento" → "energía")

No interpretamos automáticamente — el usuario hace su propia conexión.

## 🔗 Relacionados
- [[Pattern Detection]]
- [[PatternDetectionService]]
- [[v1.2]]
