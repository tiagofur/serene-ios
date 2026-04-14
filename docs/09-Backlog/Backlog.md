---
tags: [backlog, todo]
updated: 2026-04-14
---

# Backlog

Tareas pendientes fuera del roadmap formal. Priorizadas por impacto.

## 🔥 P0 - Crítico (bloquea release)

### StoreKit 2 integration real
**Descripción**: UI de suscripción existe ([[TrialOfferStepView]], [[ProfileView]]) pero no hay transacción real ni receipt validation.
**Impacto**: Bloquea conversión a Pro
**Estimate**: 3-5 días
**Owner**: TBD
**Files**: nuevo `Services/StoreKitService.swift`, modificar `TrialOfferStepView.swift`, `ProfileView.swift`

### Crisis Detection
**Descripción**: Detectar keywords de crisis en gratitudes y respuestas; redirigir a recursos.
**Impacto**: Safety crítico para App Store review
**Estimate**: 2-3 días
**Files**: `Services/AICoachService.swift`, `Services/DifficultModeService.swift`, nuevo `Services/CrisisDetectionService.swift`

### Bundle de fuentes
**Descripción**: Las fuentes DM Serif Display + Plus Jakarta Sans no están en el bundle. Se usan fallbacks de sistema.
**Impacto**: Visual no coincide con Design System completo
**Estimate**: 30 min
**Files**: `Resources/Fonts/`, `Info.plist`, `SereneTypography.swift` (cambiar fallbacks)

## 🟠 P1 - Alto

### Test Coverage Inicial
**Descripción**: 0% test coverage actualmente. Mínimo: tests de servicios.
**Estimate**: 1 semana
**Files**: nuevo `SereneTests/` target

### Login UI
**Descripción**: AuthService implementado pero no hay UI de login. La app funciona local-only sin cuenta.
**Decisión**: ¿Forzar login post-onboarding o mantener opcional? Ver [[ADR - Optional Login]] (TODO)
**Estimate**: 2 días

### Network reachability indicator
**Descripción**: Mostrar pequeño badge cuando offline. Hoy fallamos silenciosamente.
**Estimate**: 0.5 día
**Files**: nuevo `Utils/NetworkMonitor.swift`, integrar en `MainTabView`

### Onboarding analytics
**Descripción**: Track pasos completados y drop-off por step.
**Estimate**: 2 días (necesita servicio analytics)
**Files**: nuevo `Services/AnalyticsService.swift`

### Photo attachment en gratitudes
**Descripción**: PRD §3.1 menciona "Foto adjunta - Cámara o galería". Hoy hay botón placeholder.
**Estimate**: 1-2 días
**Files**: `WritingSheetView.swift`, `GratitudeEntry.swift` (ya tiene `photoURL: String?`)

## 🟡 P2 - Medio

### Localization EN
**Descripción**: Hoy es ES-only. PRD menciona EN como soportado.
**Estimate**: 2-3 días
**Files**: `Localizable.xcstrings`, todos los strings en views

### Stop words extraído a Constants
**Descripción**: Stop words duplicadas en [[WeeklySummaryService]] y [[PatternDetectionService]].
**Estimate**: 30 min
**Files**: nuevo `Constants/StopWords.swift`

### Migración SwiftData con tests
**Descripción**: SwiftData hace migrations automáticas pero no tenemos tests.
**Estimate**: 1 día

### Settings: idioma manual override
**Descripción**: Hoy [[ProfileView]] muestra "Español" hardcoded sin selector.
**Estimate**: 1 día (ligado a localization)

### Re-engagement notifications
**Descripción**: Push notifications a usuarios churned (sin hábito) o post-trial expirado.
**Estimate**: 3 días + backend

## 🟢 P3 - Bajo

### Animation polish
- Reducir motion para usuarios con `accessibility.reduceMotion`
- Spring presets en Constants
- Preview tweaks

### Accessibility audit
- VoiceOver labels en todos los componentes interactivos
- Dynamic Type support
- Color contrast verification (algunos sage en oscuro pueden ser low)

### Empty states polish
- Ilustraciones custom en lugar de SF Symbols genéricos
- Copy variants A/B testing

### Voice memo (preparación v2.0)
- Spike técnico de Speech framework
- UX para grabación + transcripción

## ❄️ Hielo (ideas no priorizadas)

- Lock screen widget
- Apple Watch complication
- Siri shortcut "Add gratitude"
- Spotlight search en historial
- Haptic feedback en celebración (controlado)
- Modo focus iOS integration
- Atajo ⌘+G en iPad keyboard

## 📋 Cómo trabajar este backlog

1. Pick item según prioridad y capacidad
2. Crear branch `feat/<name>`
3. Mover a [[Technical Debt]] si descubres deuda relacionada
4. Mover a [[Ideas]] si decides no hacerlo

## 🔗 Relacionados
- [[Technical Debt]]
- [[Ideas]]
- [[MOC - Roadmap]]
