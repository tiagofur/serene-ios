---
tags: [product, design, screens]
updated: 2026-04-14
---

# Screen Inventory

Inventario completo de pantallas en la app.

## 🚪 Onboarding (6 pantallas)

| # | Pantalla | Componente |
|---|---|---|
| 1 | Bienvenida + estado emocional | [[WelcomeStepView]] |
| 2 | La ciencia de la gratitud | [[ScienceStepView]] |
| 3 | Primera gratitud | [[FirstGratitudeStepView]] |
| 4 | Respuesta del coach ⭐ | [[CoachResponseStepView]] |
| 5 | Hora del ritual | [[ReminderStepView]] |
| 6 | Trial Pro offer | [[TrialOfferStepView]] |

## 📑 Tabs principales (4)

| Tab | Pantalla | Default? |
|---|---|---|
| 1 | [[TodayView]] | ✅ |
| 2 | [[HistoryView]] | |
| 3 | [[InsightsView]] | |
| 4 | [[ProfileView]] | |

## 📝 Modals/Sheets

| Sheet | Trigger |
|---|---|
| [[WritingSheetView]] | Tap slot en TodayView |
| [[DifficultModeView]] | Tap "No encuentro nada hoy" en WritingSheet (Pro) |
| [[CelebrationOverlayView]] | Auto al completar 3/3 |
| [[StreakMilestoneView]] | Auto al alcanzar 7/30/100 |
| [[StreakRescueSheet]] | Auto si racha rescatable |
| [[HistoryFiltersView]] | Tap filter icon en HistoryView |
| [[WeeklySummaryDetailView]] | Tap weekly summary card |
| HistoryDetailSheet | Tap entry en HistoryView |

## 🧩 Componentes reutilizables

| Componente | Usado en |
|---|---|
| [[StreakCardView]] | TodayView |
| [[GratitudeSlotView]] | TodayView |
| [[CoachReplyView]] | TodayView, WritingSheet, History detail |
| [[SentimentChartView]] | InsightsView |
| [[ConnectionsView]] | InsightsView |
| [[LanguageEvolutionView]] | InsightsView |
| [[ExportPDFButton]] | HistoryView toolbar |
| ShareSheet | WeeklySummaryDetail, ExportPDFButton |
| TypingDotsView | WritingSheet, DifficultMode, Onboarding |

## 🎯 Stats

- **Total pantallas top-level**: 10 (6 onboarding + 4 tabs)
- **Total sheets/modals**: 8
- **Total Swift files de view**: 27

## 🔗 Relacionados
- [[MOC - Codebase]]
- [[File Structure]]
- [[Design System]]
