---
tags: [service, code, pro, export]
file: Serene/Services/PDFExportService.swift
version_introduced: 1.2
tier: pro
---

# PDFExportService

Exportar historial como PDF formateado. Pro feature.

## Responsabilidades
- Renderizar gratitudes a PDF US-Letter
- Cover page con nombre + count + date range
- Páginas por día con coach replies en italics

## API Pública

```swift
final class PDFExportService {
    static let shared: PDFExportService

    func exportGratitudes(
        _ entries: [GratitudeEntry],
        userName: String,
        dateRange: ClosedRange<Date>?
    ) -> URL?
}
```

Devuelve URL temporal en `FileManager.default.temporaryDirectory`.

## Páginas

### Cover page
- Background: `#FDFAF6` (Serene background)
- Title: "Mi diario de gratitud" — Georgia 40pt
- Subtitle: userName — 20pt medium
- Accent line: 80px sage bar
- Metadata: count + date range
- Footer: "Exportado desde Serene · {date}"

### Día page
- Title: día formateado en español ("Lunes, 14 de abril de 2026")
- Accent line full-width sage
- Por entry:
  - Tag header: "GRATITUD 1  😊" en gris
  - Texto en 13pt regular
  - Coach reply en italics 12pt con barra accent sage de 2px a la izquierda
  - Separator entre entries

### Page break
Si `y > pageHeight - 140` → `context.beginPage()`

## Tech detail

```swift
let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
try renderer.writePDF(to: tempURL) { ctx in
    renderCoverPage(...)
    for (date, dayEntries) in grouped {
        renderDayPage(...)
    }
}
```

## Document metadata

```swift
format.documentInfo = [
    kCGPDFContextCreator as String: "Serene",
    kCGPDFContextAuthor as String: userName,
    kCGPDFContextTitle as String: "Mi Diario de Gratitud",
]
```

## Filename convention

`serene-gratitud-{epoch}.pdf` — único por export.

## ⚠️ Limitaciones

- ❌ Sin imágenes (cuando se añadan fotos en gratitudes, ver TODO)
- ❌ Sin emojis en texto formal (UIFont no soporta bien)
- ❌ Solo US-Letter (no A4) — TODO: detectar locale
- ❌ Tipografía system, no usa DM Serif

## 🔗 Relacionados
- [[PDF Export]]
- [[ExportPDFButton]]
- [[Monetization Model]] (Pro feature)
- [[v1.2]]
