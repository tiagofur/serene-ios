---
tags: [feature, history]
status: completed
version_introduced: 1.0
extended: 1.1
---

# History View

Lista cronológica de tus gratitudes con búsqueda y filtros.

## 🎨 Estructura

Per [[HistoryView]]:
1. NavigationStack con title "Historial"
2. Search bar nativa (`.searchable`)
3. Toolbar:
   - Export PDF (Pro) → ver [[PDF Export]]
   - Filters icon → abre [[HistoryFiltersView]]
4. ScrollView con sections agrupadas por fecha
5. Bottom banner con upgrade prompt para Free users

## 📅 Agrupación por fecha

Usa `Date.relativeDescription`:
- "Hoy"
- "Ayer"
- Fecha media ("14 de abril de 2026")

## 🔍 Filtros (v1.1)

Ver [[History Filters]]:
- Date range picker
- Mood selector (5 emojis)
- Extras only toggle

Filter pills aparecen scrollables horizontalmente cuando active. Tap remueve el filtro individual.

## 🚫 Free tier limit

Free users: máximo **7 días** de historial visible.

```swift
if appState.userTier == .pro {
    entries = allGratitudes
} else {
    entries = allGratitudes.filter { $0.createdAt >= sevenDaysAgo }
}
```

Banner "Historial completo con Pro" en bottom.

## 📄 Detail

Tap en entry abre [[HistoryDetailSheet]] (medium/large detents) con:
- Fecha + emoji
- Texto completo
- Coach reply (si existe)

## 🔗 Implementación

- View: [[HistoryView]]
- Filter view: [[HistoryFiltersView]]
- Filter model: `HistoryFilter` struct
- Card: `HistoryEntryCard` (private)
- Detail: `HistoryDetailSheet` (private)

## 🔗 Relacionados
- [[History Filters]]
- [[PDF Export]]
- [[Monetization Model]]
