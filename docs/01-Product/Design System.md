---
tags: [product, design, design-system]
updated: 2026-04-14
---

# Design System

Sistema de diseño "tierra orgánica". Cálido, natural, nunca clínico.

## 🎨 Filosofía visual

Serene evita intencionalmente los azules/púrpuras clínicos típicos de apps de salud mental. Los colores evocan calidez, naturaleza y presencia.

> _"Debe sentirse como una taza de café caliente, no como un dashboard de analytics."_

## 🌈 Paleta de colores

### Modo claro

| Token | Hex | Uso |
|---|---|---|
| `background` | `#FDFAF6` | Fondo principal |
| `surface` | `#F4EFE8` | Cards, slots |
| `cardElevated` | `#FFFFFF` | Modales, overlays |
| `accentEarth` | `#7C6E5A` | Textos secundarios, borders |
| `sage` | `#5A7A6B` | CTA principales, tab activo, racha |
| `sageSoft` | `#E0EDE7` | Fondos sage |
| `arena` | `#C4956A` | Extras desbloqueados, logros |
| `arenaSoft` | `#F5EAD8` | Fondos arena |
| `rosa` | `#C0706E` | Elementos emocionales |
| `rosaSoft` | `#F5E4E3` | Fondos rosa |
| `textPrimary` | `#2D2420` | Texto principal |
| `textSecondary` | `#7C6E5A` | Labels |
| `textTertiary` | `#9E8A78` | Placeholders |
| `borderDefault` | `#D4C5B0` | Borders cards |

### Modo oscuro

| Token | Hex | Uso |
|---|---|---|
| `background` | `#17130F` | Fondo principal |
| `surface` | `#221C16` | Cards |
| `cardElevated` | `#2C2419` | Modales |
| `sage` | `#8BBCA8` | CTA (más claro vs light) |
| `arena` | `#E0A87A` | Extras |
| `rosa` | `#D98F8D` | Emocional |
| `textPrimary` | `#F2EBE3` | Texto principal |
| `textSecondary` | `#B09A8C` | Labels |
| `textTertiary` | `#6E5E54` | Placeholders |
| `borderDefault` | `#3A2E22` | Borders |

Implementación: [[SereneColors]] con `Light` y `Dark` enum + helpers que reciben `ColorScheme`.

## 🔤 Tipografía

| Rol | Fuente | Tamaño | Peso | Uso |
|---|---|---|---|---|
| Display | DM Serif Display | 28-32pt | Regular | Saludo, títulos grandes, unlock |
| Heading | Plus Jakarta Sans | 18-22pt | SemiBold (600) | Títulos sección |
| Body | Plus Jakarta Sans | 14-15pt | Regular (400) | Texto gratitudes, coach |
| Label | Plus Jakarta Sans | 11-12pt | Medium (500) | Metadata, tags |
| Micro | Plus Jakarta Sans | 10pt | Medium (500) | Status, tabs |

### Regla clave
> **DM Serif Display** solo para momentos emocionales: saludo, celebración unlock, weekly summary.
> **Plus Jakarta Sans** para todo lo funcional.

⚠️ **TODO**: Las fuentes deben bundlearse en `Resources/Fonts/`. Hoy se usan fallbacks de sistema (`.serif` para display, `.default` para sans).

Implementación: [[SereneTypography]] con extensions `View.sereneDisplay()`, `.sereneHeading()`, etc.

## 📏 Espaciado y radios

### Spacing
| Token | Valor | Uso |
|---|---|---|
| `xs` | 4px | Gap mínimo inline |
| `sm` | 8px | Gap interno componentes pequeños |
| `md` | 16px | Padding interno cards |
| `lg` | 24px | Separación secciones |
| `xl` | 40px | Espaciado pantalla, márgenes |

### Radius
| Token | Valor | Uso |
|---|---|---|
| `sm` | 8px | Botones pequeños, pills |
| `md` | 12px | Cards, coach reply |
| `lg` | 16px | Slots, overlays |
| `xl` | 24px | Extra slots, modal principal |

### Border width
| Token | Valor |
|---|---|
| `default` | 0.5px |
| `emphasis` | 1.5px |

Implementación: [[SereneSpacing]] con structs `Spacing`, `Radius`, `BorderWidth`.

## 🎭 Tema (Theme modifiers)

[[SereneTheme]] introduce:
- `SereneSurfaceModifier` — surface fill + border default
- `SerenePrimaryButtonStyle` — sage filled, white text
- `SereneSecondaryButtonStyle` — sage outlined
- `SerenePressableStyle` — scale 0.97 + opacity 0.85 on press
- `AppAppearance` enum — system / light / dark

Uso:
```swift
.sereneSurface()
.buttonStyle(SerenePrimaryButtonStyle())
```

## 🎨 Estados de elementos

### Slots de gratitud
Ver [[GratitudeSlotView]] enum:
- `.empty`: dashed border default
- `.active`: solid sage 1.5px (siguiente a llenar)
- `.done`: surface fill + check
- `.extraLocked`: dashed + lock icon
- `.extraUnlocked`: solid arena 1.5px + tag pill

### Coach reply
- Sage soft fill 50% opacity
- Avatar 20px sage circle con sparkle
- Body 14pt en text secondary

## 🏞️ Iconografía

Solo SF Symbols. Sin assets custom.

Comunes:
- `leaf` — tab Hoy
- `book` — tab Historial
- `sparkles` — tab Insights / Pro features
- `person.circle` — tab Perfil
- `flame.fill` — racha
- `heart.circle.fill` — rescate
- `crown.fill` — Pro badge
- `sparkle` — coach avatar
- `link.circle` — connections

## 🎬 Animaciones

### Defaults
- Spring response 0.3-0.5, damping 0.7-0.85
- Ease durations 0.3-0.4 para fades
- Char-by-char typing: 28ms/char (per PRD)
- Typing dots: 350ms cycle

### Celebration overlay (PRD-spec)
Ver [[CelebrationOverlayView]]:
- t=0: partículas
- t=80ms: overlay slide-up + opacity
- t=150ms: ring pop-in
- t=300ms: streak pop
- t=400ms: title slide
- t=550ms: subtitle slide
- t=900ms: extra 1
- t=1100ms: extra 2

## 🚫 Anti-patterns

- ❌ Azules/púrpuras clínicos
- ❌ Confetti explosion en celebraciones
- ❌ Drop shadows pesados (apenas usamos)
- ❌ Border radius muy chico (<8px) — sentirse técnico
- ❌ Iconografía custom — preferir SF Symbols

## 🔗 Relacionados
- [[SereneColors]]
- [[SereneTypography]]
- [[SereneSpacing]]
- [[SereneTheme]]
- [[Vision]]
- [[Color Tokens]]
- [[Typography]]
