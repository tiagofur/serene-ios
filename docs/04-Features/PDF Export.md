---
tags: [feature, pro, export]
status: completed
version_introduced: 1.2
tier: pro
---

# PDF Export

Exportar historial completo como PDF formateado. Pro feature.

## 🎯 UX

[[ExportPDFButton]] aparece en toolbar de [[HistoryView]] cuando user es Pro.

```
[Tap "Exportar a PDF"]
    ↓
[Loading state: ProgressView + "Generando..."]
    ↓
[PDF rendered to temp file]
    ↓
[UIActivityViewController abre con opciones de share]
    ↓
User puede: AirDrop, Mail, Files, Print, Notes...
```

## 📄 Estructura del PDF

### Cover page
- Background warm (`#FDFAF6`)
- Title "Mi diario de gratitud" — Georgia 40pt
- User name 20pt medium
- Accent line sage 80px
- Metadata: count + date range
- Footer "Exportado desde Serene · {date}"

### Día pages (una por día con entries)
- Title del día en español ("Lunes, 14 de abril de 2026")
- Accent line full-width sage
- Entries:
  - Tag header "GRATITUD 1  😊"
  - Texto 13pt
  - Coach reply en italics 12pt con barra accent sage 2px

### Pagination
Auto-break cuando `y > pageHeight - 140`.

## 🎨 Design tokens

| Elemento | Color hex |
|---|---|
| Background | `#FDFAF6` |
| Text primary | `#2D2420` |
| Text tertiary | `#9E8A78` |
| Sage accent | `#5A7A6B` |
| Border | `#D4C5B0` |

Coincide con [[Design System]] modo claro.

## 🔧 Tech detail

Per [[PDFExportService]]:
- `UIGraphicsPDFRenderer` US-Letter (612×792)
- `UIFont(name: "Georgia", size: ...)` para serif
- `UIColor(Color(hex: ...))` para tokens

## 📤 Sharing

`ShareSheet` (UIActivityViewController wrapper) permite:
- AirDrop
- Mail
- Files
- Print
- Save to Notes
- 3rd party apps

## ⚠️ Limitaciones

- ❌ Solo US-Letter (no A4) — TODO localizar
- ❌ Sin imágenes adjuntas (cuando se añadan en gratitudes)
- ❌ Emoji rendering depende de UIFont — algunos pueden no aparecer
- ❌ No usa DM Serif Display (usa Georgia como fallback)

## 🔗 Relacionados
- [[PDFExportService]]
- [[ExportPDFButton]]
- [[HistoryView]]
- [[Monetization Model]]
- [[v1.2]]
