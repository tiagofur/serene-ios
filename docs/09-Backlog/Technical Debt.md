---
tags: [backlog, debt]
updated: 2026-04-14
---

# Technical Debt

Deuda técnica conocida que no es bloqueante pero requiere atención.

## 💸 Deuda de código

### `AppState` duplica `UserProfile`
**Síntoma**: `AppState.userName` en UserDefaults Y `UserProfile.name` en SwiftData.
**Razón**: SwiftUI necesita acceso síncrono a ciertos campos sin pasar por `@Query`.
**Riesgo**: Inconsistencia si uno se actualiza y el otro no.
**Solución propuesta**: Crear `@Observable` wrapper que reactivamente expone `UserProfile.first`.
**Cuándo**: [[v2.0]] cuando refactoricemos para multi-account.

### Stop words duplicadas
**Archivos**: `WeeklySummaryService.swift`, `PatternDetectionService.swift`
**Solución**: Extraer a `Constants/StopWords.swift`
**Effort**: 30 min · ver [[Backlog]]

### `extension X: @retroactive Identifiable` en views
**Files**: `HistoryView.swift`, `InsightsView.swift`
**Razón**: SwiftData `@Model` no es `Identifiable` automáticamente cuando se usa `.sheet(item:)`
**Solución**: Mover extensions a archivo dedicado `Extensions/SwiftDataIdentifiable.swift`
**Effort**: 5 min

### `AICoachService.getCoachResponse` doble path
**Síntoma**: Respuesta cloud llega en POST /gratitudes; pero si falla, fallback se hace en VM.
**Razón**: Originalmente cloud era un endpoint separado.
**Solución**: Centralizar fallback en service para que VM sólo tenga una llamada.
**Effort**: 2 horas

### Spanish hardcoded strings
**Síntoma**: Todos los strings en código.
**Solución**: Migrar a `Localizable.xcstrings` (Xcode 15+ catalog)
**Effort**: 2-3 días por lenguaje
**Cuándo**: [[v2.0]] para PT-BR launch

## 🏗️ Deuda de arquitectura

### Sin sync engine real
**Síntoma**: Cada `POST /gratitudes` es individual. No batch sync ni conflict resolution.
**Riesgo**: Cuando habilitemos multi-device en [[v2.0]], conflicts.
**Solución**: Implementar [[Sync Engine]] (TODO crear ADR-006)
**Effort**: 1-2 semanas

### Sin retry logic en `APIService`
**Síntoma**: Falla → fallback inmediato. No reintentos transparentes.
**Riesgo**: Pérdida de cloud responses por flaky network temporal.
**Solución**: Wrapper retry con backoff exponencial (max 3, jitter)
**Effort**: 0.5 día

### Servicios singleton sin DI
**Síntoma**: `static let shared` en todos los services.
**Riesgo**: Difícil de testear (mocks).
**Solución**: Protocol-based DI con SwiftUI Environment.
**Effort**: 1 semana
**Cuándo**: cuando empecemos test coverage seriamente

### Sin error tracking centralizado
**Síntoma**: `print(error)` en varios servicios.
**Solución**: `LoggingService` + integración con Sentry/Crashlytics
**Effort**: 1 día

## 🔒 Deuda de seguridad

### Keychain sin accessibility level
**Síntoma**: `KeychainHelper` no especifica `kSecAttrAccessible`
**Default**: `kSecAttrAccessibleWhenUnlocked` (OK pero implícito)
**Solución**: Hacer explícito `kSecAttrAccessibleAfterFirstUnlock` para token
**Effort**: 5 min

### SwiftData store sin file protection
**Síntoma**: SQLite default protection class
**Solución**: `NSPersistentStoreFileProtectionKey = NSFileProtectionComplete` (cuando app esté abierta)
**Trade-off**: Background notifications no podrán leer
**Effort**: 2 horas + testing

## 🧪 Deuda de testing

### 0% coverage actual
- No unit tests
- No UI tests
- No integration tests

**Mínimo viable**:
- Tests de servicios (especialmente PatternDetection algorithms)
- Snapshot tests de views principales
- Critical path: onboarding → first gratitude → save

**Effort**: 1-2 semanas inicial + cultura de PRs con tests

## 📊 Deuda de observabilidad

### Sin analytics
**Síntoma**: No sabemos D1/D7/D30, drop-off en onboarding, qué slots se usan más
**Riesgo crítico para el negocio**
**Solución**: Telemetry service (privacy-respecting, opt-in)
**Effort**: 3 días

### Sin AB testing infra
**Síntoma**: No podemos testear copy/UI variants
**Solución**: Backend-driven feature flags
**Effort**: 1 semana

## 🎯 Cómo abordar esta deuda

1. **Cada PR**: si tocas código deuda, considera fix as part of
2. **Mensual**: review backlog de deuda, mover a [[Backlog]] lo prioritario
3. **Por release**: dedicar 20% de capacidad a deuda

## 🔗 Relacionados
- [[Backlog]]
- [[Ideas]]
- [[Coding Standards]]
