---
tags: [adr, architecture, accepted]
adr_number: 003
status: accepted
date: 2026-04-14
---

# ADR-003 — MVVM Pattern (Pragmatic)

## Status
**Accepted** · 2026-04-14

## Contexto
SwiftUI permite varios paradigmas:
- Pure SwiftUI (state en `@State` + `@Query` directo)
- MVVM clásico (`ObservableObject` por screen)
- TCA (The Composable Architecture)
- Redux-style con un store global

## Decisión

**MVVM pragmático**: ViewModels solo para screens con lógica compleja, `@Query` directo para screens simples.

### Cuándo usar ViewModel
- ✅ La screen tiene >2 pieces de async state
- ✅ Hay business logic que no es trivial
- ✅ Hay que coordinar múltiples servicios
- ✅ Necesitas testear lógica sin UI

Ejemplos: [[TodayViewModel]], [[OnboardingViewModel]]

### Cuándo NO usar ViewModel
- ✅ La screen es read-only de datos local
- ✅ No hay state mutable más allá de `@State` simple

Ejemplos: [[InsightsView]], [[HistoryView]] (usan `@Query` y `@State` directo)

## Consecuencias

### Positivas
- ✅ Menos boilerplate en screens simples
- ✅ Mayor velocidad de desarrollo
- ✅ Familiar para iOS devs
- ✅ Testeable cuando importa
- ✅ No requiere learn TCA

### Negativas
- ❌ Inconsistencia: dos patrones en codebase
- ❌ Algunas screens crecen y se debería refactorizar a VM
- ❌ Menos predictibilidad vs Redux/TCA

### Mitigations
- En PRs: si una screen `@State` crece >5 propiedades, sugerir VM
- Convención: VM live en `ViewModels/` con sufijo `ViewModel`
- VM siempre `@MainActor final class ViewModelName: ObservableObject`

## Estructura VM estándar

```swift
@MainActor
final class FeatureViewModel: ObservableObject {
    // MARK: - Published State
    @Published var ...

    // MARK: - Computed
    var ...

    // MARK: - Data Operations
    func loadData(context: ModelContext) { ... }

    // MARK: - User Actions
    func onUserAction() async { ... }
}
```

## Alternativas consideradas

### TCA (The Composable Architecture)
- ✅ Type-safe state management
- ❌ Curva de aprendizaje alta
- ❌ Verbose para features simples
- **Veredicto**: Overkill para Serene; reconsider si crecemos a >100 screens

### Redux global
- ❌ Sobre-ingeniería para una app de 4 tabs
- ❌ Performance issues con state updates frecuentes

## 🔗 Relacionados
- [[TodayViewModel]]
- [[OnboardingViewModel]]
- [[Coding Standards]]
