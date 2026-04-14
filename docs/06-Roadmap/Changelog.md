---
tags: [changelog, roadmap]
updated: 2026-04-14
---

# Changelog

Registro detallado de todos los cambios entregados.

## [v1.2] — Commit `b6c76a1` (2026-04-14)

### Added
- **[[Pattern Detection]]**: `PatternDetectionService` con análisis on-device de conexiones emocionales, evolución del lenguaje y serie temporal de sentimiento usando `NaturalLanguage.NLTagger`
- **[[Difficult Mode]]**: Coach conversacional Socrático para días bloqueados
  - `DifficultModeService` con cloud endpoint + local fallback tree
  - `DifficultModeView` con chat UI, typing dots, suggestion card
  - Trigger en `WritingSheetView` (Pro only): "No encuentro nada hoy"
- **[[PDF Export]]**: `PDFExportService` con `UIGraphicsPDFRenderer` US-Letter
  - Cover page personalizada
  - Páginas por día con coach replies en itálicas
  - `ExportPDFButton` en toolbar de History (Pro)
- **[[Sentiment Chart]]**: `SentimentChartView` con Swift Charts (línea + área degradada, CatmullRom interpolation)
- **[[Unexpected Connections]]**: `ConnectionsView` con narrativas automáticas
- **[[Language Evolution]]**: `LanguageEvolutionView` con FlowLayout custom

### Changed
- `InsightsView`: 3 nuevas vistas Pro integradas, paywall actualizado a 6 features v1.2
- `HistoryView`: Botón Export PDF en toolbar para Pro
- `WritingSheetView`: Inyecta `EnvironmentObject AppState` para tier check

---

## [v1.1] — Commit `7b8aa26` (2026-04-14)

### Added
- **[[Weekly Summary]]**: `WeeklySummaryService` genera narrativas tipo "Esta semana, X, tu mente estuvo en dos lugares: A y B"
  - Top topics extraction (stop words filtering)
  - Dominant emoji + sentiment trend (ascending/stable/reflective)
  - Auto-generación los lunes
  - Free: 1/mes · Pro: ilimitado
  - `WeeklySummaryDetailView` compartible como imagen via `ImageRenderer`
- **[[Smart Notifications]]**: `SmartNotificationService`
  - Detecta hora habitual de últimas 14 días
  - Nudge soft 15 min antes (interruption: passive)
  - Streak protection a las 22:00 (interruption: timeSensitive)
  - Milestone push al alcanzar 7/30/100
- **[[Streak Rescue]]**: `StreakRescueSheet` + `StreakData.useRescue()`
  - 1x/mes con reset automático
  - Sólo si racha ≥3 y missed yesterday
- **[[Streak Milestones]]**: `StreakMilestoneView` 7/30/100 con animación secuenciada
- **[[History Filters]]**: `HistoryFiltersView` con date range + mood + extras-only
  - Active filter pills con removal individual
- **[[Appearance Settings]]**: Enum `AppAppearance` (system/light/dark) persistido
  - `preferredColorScheme` aplicado a nivel app
  - Picker en Profile

### Changed
- `TodayViewModel`: Lógica completa de milestones + rescue + smart nudge scheduling
- `TodayView`: Integra `StreakMilestoneView` y `StreakRescueSheet`
- `InsightsView`: Auto-genera resumen, histórico para Pro
- `HistoryView`: Reconstruido con filtros, agrupación relativa (Hoy/Ayer/fecha)
- `ProfileView`: Menú apariencia, contador rescates disponibles
- `AppState`: Persiste `appearance` en UserDefaults

### Added (infra)
- `SereneTheme.swift` con `SereneSurfaceModifier`, `SerenePrimaryButtonStyle`, `SerenePressableStyle`

---

## [v1.0 MVP] — Commit `d029de8` (2026-04-14)

### Added (initial release)

#### Architecture
- SwiftUI app structure con `SereneApp`, `MainTabView`, `AppState`
- SwiftData con 5 modelos: `GratitudeEntry`, `UserProfile`, `StreakData`, `WeeklySummaryEntry`, `PatternEntry`
- 5 servicios base: `APIService`, `AuthService`, `GratitudeService`, `AICoachService`, `NotificationService`
- 2 ViewModels: `TodayViewModel`, `OnboardingViewModel`
- Offline-first sync con SwiftData primary + REST sync

#### Design System
- Color tokens light + dark mode (warm earth palette)
- Typography fallbacks DM Serif Display + Plus Jakarta Sans
- Spacing scale (xs/sm/md/lg/xl) y radius scale

#### Features
- **[[3+2 Mechanic]]**: 3 base + 2 extras desbloqueables
- **[[AI Coach]]**: Respuesta inline con typing animation 28ms/char
- **[[Streak System]]**: Card + 7-dot week display
- **[[Onboarding Flow]]**: 6 pasos, respuesta del coach ANTES del paywall (regla crítica PRD)
- **Tab navigation**: 4 tabs sin badges numéricos
- **Free vs Pro gating**: 7 días history, 1 monthly summary

#### Views
- 16 vistas: Onboarding (6), Today (5), Writing (1), History (1), Insights (1), Profile (1), MainTab (1)
- `CelebrationOverlayView` con animación secuenciada según PRD spec (partículas t=0, ring t=150ms, etc)

### Infrastructure
- Info.plist con permissions (camera, photo library, notifications)
- Package.swift para iOS 17+

---

## Convención Semantic Versioning

- **MAJOR** (1.x → 2.x): Cambios disruptivos, nueva plataforma
- **MINOR** (1.0 → 1.1): Nuevas features, no rompe compat
- **PATCH** (1.1.0 → 1.1.1): Bug fixes, polish

---

## 🔗 Relacionados
- [[MOC - Roadmap]]
- [[Backlog]]
- [[Technical Debt]]
