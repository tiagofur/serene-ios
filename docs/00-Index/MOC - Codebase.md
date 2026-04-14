---
tags: [moc, codebase]
updated: 2026-04-14
---

# MOC - Codebase

Mapa del código implementado. 51 archivos Swift organizados en capas.

## 📁 Estructura

```
Serene/
├── App/                  ← Entry point + AppState
├── Models/               ← 5 @Model SwiftData
├── Design/               ← Sistema de diseño (colores, tipografía, tema)
├── Services/             ← 8 servicios de negocio
├── ViewModels/           ← MVVM — 2 view models principales
├── Views/
│   ├── Onboarding/       ← 6 pasos
│   ├── Today/            ← Pantalla principal
│   ├── Writing/          ← Sheet + difficult mode
│   ├── History/          ← Lista + filtros + PDF export
│   ├── Insights/         ← Sumarios + patrones + gráficas
│   ├── Profile/          ← Settings + suscripción
│   └── Components/       ← Compartidos (milestones, rescue)
├── Extensions/           ← Date extensions
└── Resources/            ← Fuentes y assets
```

Ver [[File Structure]] para árbol completo.

## 🔧 Servicios

| Servicio | Propósito | Doc |
|---|---|---|
| APIService | HTTP client central con JWT | [[APIService]] |
| AuthService | Login, register, Keychain | [[AuthService]] |
| GratitudeService | CRUD + offline-first sync | [[GratitudeService]] |
| AICoachService | Respuestas coach (cloud + local) | [[AICoachService]] |
| NotificationService | Notificaciones básicas | [[NotificationService]] |
| SmartNotificationService | Detecta hora habitual, nudge 15min | [[SmartNotificationService]] |
| WeeklySummaryService | Narrativa semanal + análisis | [[WeeklySummaryService]] |
| PatternDetectionService | Conexiones, evolución lenguaje | [[PatternDetectionService]] |
| DifficultModeService | Coach conversacional | [[DifficultModeService]] |
| PDFExportService | Export a PDF US-Letter | [[PDFExportService]] |

## 🎨 Design System

- [[SereneColors]] — Tokens light/dark
- [[SereneTypography]] — DM Serif + Plus Jakarta
- [[SereneSpacing]] — Scale: xs/sm/md/lg/xl
- [[SereneTheme]] — ViewModifiers + ButtonStyles

## 🖼️ Views principales

### Onboarding
- [[WelcomeStepView]] — Nombre + estado emocional
- [[ScienceStepView]] — La ciencia de la gratitud
- [[FirstGratitudeStepView]] — Escribir primera gratitud
- [[CoachResponseStepView]] — ⭐ Pantalla crítica
- [[ReminderStepView]] — Hora del ritual
- [[TrialOfferStepView]] — Trial Pro sin presión

### Today
- [[TodayView]] — Pantalla principal
- [[StreakCardView]] — Racha + 7 dots
- [[GratitudeSlotView]] — Slots 3+2
- [[CoachReplyView]] — Reply inline
- [[CelebrationOverlayView]] — Unlock extras
- [[StreakMilestoneView]] — 7/30/100 días
- [[StreakRescueSheet]] — Rescate 1x/mes

### Writing
- [[WritingSheetView]] — Bottom sheet
- [[DifficultModeView]] — Coach conversacional

### History
- [[HistoryView]] — Lista + búsqueda
- [[HistoryFiltersView]] — Filtros fecha/mood
- [[ExportPDFButton]] — Export PDF

### Insights
- [[InsightsView]] — Pantalla principal
- [[WeeklySummaryDetailView]] — Compartible como imagen
- [[SentimentChartView]] — Swift Charts
- [[ConnectionsView]] — Conexiones inesperadas
- [[LanguageEvolutionView]] — 30 vs 60 días

### Profile
- [[ProfileView]] — Stats + settings + suscripción

## 🧩 ViewModels
- [[TodayViewModel]]
- [[OnboardingViewModel]]

## 🔗 Relacionados
- [[MOC - Architecture]]
- [[MOC - Features]]
- [[Getting Started]]
