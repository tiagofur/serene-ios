---
tags: [architecture, structure]
updated: 2026-04-14
---

# File Structure

Estructura completa de archivos del proyecto.

## 🌳 Árbol completo

```
serene-ios/
├── PRD/                              ← Documentos producto originales (no tocar)
├── docs/                             ← Esta documentación (Obsidian vault)
└── Serene/                           ← Código de la app
    ├── App/
    │   ├── SereneApp.swift           Entry point + ModelContainer
    │   └── AppState.swift            Global state (UserDefaults-backed)
    │
    ├── Models/                       SwiftData @Model
    │   ├── GratitudeEntry.swift
    │   ├── UserProfile.swift
    │   ├── StreakData.swift
    │   ├── WeeklySummaryEntry.swift
    │   └── PatternEntry.swift
    │
    ├── Design/                       Sistema de diseño
    │   ├── SereneColors.swift        Tokens light + dark
    │   ├── SereneTypography.swift    Fonts + helpers
    │   ├── SereneSpacing.swift       Spacing + Radius + BorderWidth
    │   └── SereneTheme.swift         ViewModifiers + ButtonStyles
    │
    ├── Services/                     Capa de negocio (singletons)
    │   ├── APIService.swift          HTTP client central
    │   ├── AuthService.swift         JWT + Keychain
    │   ├── GratitudeService.swift    CRUD + offline sync
    │   ├── AICoachService.swift      Coach responses
    │   ├── NotificationService.swift Reminders básicos
    │   ├── SmartNotificationService.swift  Habit detection + nudges
    │   ├── WeeklySummaryService.swift      Narrativa + analysis
    │   ├── PatternDetectionService.swift   Connections + evolution
    │   ├── DifficultModeService.swift      Coach conversacional
    │   └── PDFExportService.swift          PDF rendering
    │
    ├── ViewModels/                   MVVM
    │   ├── TodayViewModel.swift
    │   └── OnboardingViewModel.swift
    │
    ├── Views/
    │   ├── MainTabView.swift         Tab bar (4 tabs)
    │   │
    │   ├── Onboarding/               6 pasos
    │   │   ├── OnboardingView.swift
    │   │   ├── WelcomeStepView.swift
    │   │   ├── ScienceStepView.swift
    │   │   ├── FirstGratitudeStepView.swift
    │   │   ├── CoachResponseStepView.swift   ⭐ Crítica
    │   │   ├── ReminderStepView.swift
    │   │   └── TrialOfferStepView.swift
    │   │
    │   ├── Today/
    │   │   ├── TodayView.swift
    │   │   ├── StreakCardView.swift
    │   │   ├── GratitudeSlotView.swift
    │   │   ├── CoachReplyView.swift
    │   │   └── CelebrationOverlayView.swift
    │   │
    │   ├── Writing/
    │   │   ├── WritingSheetView.swift
    │   │   └── DifficultModeView.swift
    │   │
    │   ├── History/
    │   │   ├── HistoryView.swift
    │   │   ├── HistoryFiltersView.swift
    │   │   └── ExportPDFButton.swift
    │   │
    │   ├── Insights/
    │   │   ├── InsightsView.swift
    │   │   ├── WeeklySummaryDetailView.swift  Compartible
    │   │   ├── SentimentChartView.swift       Swift Charts
    │   │   ├── ConnectionsView.swift
    │   │   └── LanguageEvolutionView.swift    FlowLayout custom
    │   │
    │   ├── Profile/
    │   │   └── ProfileView.swift
    │   │
    │   └── Components/               Compartidos
    │       ├── StreakMilestoneView.swift
    │       └── StreakRescueSheet.swift
    │
    ├── Extensions/
    │   └── DateExtensions.swift      isToday, startOfWeek, etc
    │
    ├── Resources/
    │   └── Fonts/                    DM Serif Display + Plus Jakarta (TODO)
    │
    ├── Info.plist
    └── Package.swift                 SPM manifest
```

## 📊 Conteo

| Categoría | Archivos |
|---|---|
| App | 2 |
| Models | 5 |
| Design | 4 |
| Services | 10 |
| ViewModels | 2 |
| Views | 27 |
| Extensions | 1 |
| **Total Swift** | **51** |

## 🎯 Patrones de organización

### 1. Por capa primero, por feature segundo
Esto facilita encontrar archivos cuando buscas "todos los services" o "todos los modelos".

### 2. Views agrupadas por screen
Cada tab/feature mayor tiene su carpeta. `Components/` para lo que cruza features.

### 3. Singleton services con `static let shared`
Razón: SwiftUI no maneja DI bien sin Combine, y los servicios son stateless. `@MainActor` cuando tocan UI.

### 4. ViewModels per-screen, no per-feature
Algunas screens chicas (History, Insights) usan `@Query` directamente sin VM.

## 🔗 Relacionados
- [[MOC - Codebase]]
- [[Coding Standards]]
- [[Tech Stack]]
