---
tags: [feature, history, filters]
status: completed
version_introduced: 1.1
---

# History Filters

Filtros para encontrar gratitudes específicas en el historial.

## 🎯 Filtros disponibles

Per [[HistoryFiltersView]]:

### 1. Date Range
- Toggle "Filtrar por fecha"
- Two DatePickers: Desde y Hasta
- Hasta limitado por `in: startDate...`

### 2. Mood
- HStack de 5 emojis (`GratitudeMood.allCases`)
- Tap para seleccionar / deseleccionar
- Sage soft fill cuando active

### 3. Type
- Toggle "Solo extras desbloqueados"
- Para revisar respuestas a prompts reflexivos

## 🧹 Limpiar

Toolbar leading: "Limpiar" → `filter = .empty`

## ✅ Aplicar

Toolbar trailing: "Aplicar" → cierra sheet con filtro activo

## 📌 Active filter pills

En `HistoryView`, cuando filter active:
- ScrollView horizontal con FilterPill por cada filtro
- Tap pill → remove ese filtro específico
- Pill format: `[icon] texto [×]`

## 🔄 Filter logic

```swift
if let start = filter.startDate {
    entries = entries.filter { $0.createdAt >= start.startOfDay }
}
if let end = filter.endDate {
    let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: end.startOfDay)!
    entries = entries.filter { $0.createdAt < endOfDay }
}
if let mood = filter.selectedMood {
    entries = entries.filter { $0.emoji == mood }
}
if filter.extrasOnly {
    entries = entries.filter { $0.isExtra }
}
```

## 🎨 Empty state

Cuando filters retornan 0:
- Icon `magnifyingglass`
- "Sin resultados"
- Subtitle: "Intenta ajustar los filtros"

vs cuando no hay datos:
- Icon `book.closed`
- "Tu historial está vacío"

## 🔗 Relacionados
- [[History View]]
- [[v1.1]]
