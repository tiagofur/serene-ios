---
tags: [service, code, ai, summary]
file: Serene/Services/WeeklySummaryService.swift
version_introduced: 1.1
---

# WeeklySummaryService

Genera resúmenes narrativos semanales. Cloud + local fallback.

## Responsabilidades
- Detectar si la semana actual ya tiene resumen
- Validar gating Free (1/mes) vs Pro (ilimitado)
- Extraer top topics, dominant emoji, sentiment trend
- Generar narrativa cloud o local
- Persistir como [[WeeklySummaryEntry]]

## API Pública

```swift
@MainActor
final class WeeklySummaryService {
    static let shared: WeeklySummaryService

    func shouldGenerateSummary(context: ModelContext) -> Bool

    func generateWeeklySummary(
        userName: String,
        isPro: Bool,
        context: ModelContext
    ) async -> WeeklySummaryEntry?
}
```

## Algoritmo

### 1. Gating
```
if !isPro && summariesEsteMes >= 1 → return nil
if gratitudesEstaSemana < 3        → return nil
```

### 2. Análisis on-device
- **Top topics**: word frequency con stop-words filter, top 3
- **Dominant emoji**: most common emoji en entries
- **Sentiment trend**:
  - `>= 0.7` → "ascending"
  - `0.4..<0.7` → "stable"
  - `< 0.4` → "reflective"

### 3. Narrativa
- Try cloud `/insights/weekly`
- Si falla → `generateLocalNarrative(...)`

### Local narrative templates
```
"Esta semana, María, tu mente estuvo en dos lugares: familia y trabajo.
 Tu semana tuvo un tono luminoso — algo estaba creciendo dentro.
 Escribiste 18 momentos de gratitud — cada uno una pequeña semilla. 🌱"
```

Adapta según número de topics (2, 1, o 0).

### 4. Persistencia
Inserta `WeeklySummaryEntry` con `weekStart = startOfWeek`.

## Cuándo se llama

Auto-trigger en `InsightsView.task`:
- Si es lunes O
- Si no hay resumen para esta semana

## ⚠️ Limitaciones

- ❌ Stop words son ES-only (TODO: detectar idioma con `NLLanguageRecognizer`)
- ❌ No considera dominio emocional (familia ≠ casa, podríamos lemmatize)
- ❌ Cloud endpoint no implementado en backend Go aún

## 🔗 Relacionados
- [[Weekly Summary]]
- [[WeeklySummaryEntry]]
- [[AICoachService]]
- [[v1.1]]
