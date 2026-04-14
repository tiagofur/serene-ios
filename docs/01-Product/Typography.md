---
tags: [product, design, typography]
updated: 2026-04-14
---

# Typography

Sistema tipográfico. Para detalle completo ver [[Design System]].

## 🔤 Fuentes

### DM Serif Display
**Uso**: momentos emocionales (saludo, celebración unlock, weekly summary)
**Pesos**: Regular
**Tamaños**: 22-32pt típicamente

### Plus Jakarta Sans
**Uso**: UI funcional (botones, labels, body)
**Pesos**: Regular (400), Medium (500), SemiBold (600)
**Tamaños**: 10-22pt

## 📏 Escala de tamaños

| Rol | Fuente | Tamaño | Peso |
|---|---|---|---|
| Display | DM Serif Display | 28-32pt | Regular |
| Heading | Plus Jakarta Sans | 18-22pt | SemiBold |
| Body | Plus Jakarta Sans | 14-15pt | Regular |
| Label | Plus Jakarta Sans | 11-12pt | Medium |
| Micro | Plus Jakarta Sans | 10pt | Medium |

## 🎨 Section headers

Pattern especial para títulos de sección:
- 11pt
- 600 weight
- UPPERCASE
- letter-spacing 0.06em
- Color terciario

Implementación:
```swift
.sereneSectionHeader()
```

## 📐 Reglas

- **DM Serif**: solo emocional. Si dudas, no es display.
- **Hierarchy clara**: Display > Heading > Body > Label > Micro
- **Consistency**: usar helpers (`.sereneBody()`), no `.font(.system(...))`
- **Dynamic Type**: TODO — soportar accessibility text sizes

## ⚠️ Estado actual

Las fuentes NO están bundleadas. Se usan fallbacks de sistema:
- `.serif` design para display
- Default design para sans

Ver [[Backlog]] P0: bundle de fuentes.

## 🔗 Relacionados
- [[Design System]]
- [[SereneTypography]]
- [[Color Tokens]]
