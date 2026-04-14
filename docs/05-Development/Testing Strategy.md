---
tags: [development, testing]
updated: 2026-04-14
status: planned
---

# Testing Strategy

⚠️ **Estado actual**: 0% test coverage. Plan documentado, ejecución pendiente.

## 🎯 Filosofía

> Testear lo que duele cuando se rompe.

Foco en:
1. **Lógica de negocio** (servicios, view models) — alta coverage
2. **Critical paths UX** — snapshot + UI tests
3. **Edge cases conocidos** — regression tests
4. **Algorithms** (PatternDetection, Streak) — extensive unit tests

## 📊 Pirámide de tests

```
        ▲
       UI Tests
      (~5%, slow)
      ──────────
     Snapshot Tests
    (~15%, medium)
    ──────────────
   Integration Tests
  (~20%, medium)
  ────────────────
   Unit Tests
  (~60%, fast)
  ──────────────
```

## 🧪 Por capa

### Services (target: 80%+ coverage)
**Cubrir**:
- Happy path
- Network failure → fallback
- Edge cases (empty data, malformed input)
- Algorithms (sentiment scoring, pattern detection)

**Mocks**:
- `URLProtocol` mock para `URLSession`
- In-memory `ModelContainer` para SwiftData

**Ejemplos prioritarios**:
- [[GratitudeService]] save flow (online/offline)
- [[StreakData]].recordEntry edge cases (timezone, midnight)
- [[PatternDetectionService]] connection threshold
- [[WeeklySummaryService]] gating logic
- [[AICoachService]] fallback diversity

### ViewModels (target: 70%+)
**Cubrir**:
- State transitions
- Async actions
- Computed properties

**Setup**:
```swift
@MainActor
class TodayViewModelTests: XCTestCase {
    var sut: TodayViewModel!
    var container: ModelContainer!

    override func setUp() async throws {
        container = try ModelContainer(
            for: GratitudeEntry.self, StreakData.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        sut = TodayViewModel()
    }
}
```

### Views (target: snapshots de las críticas)
**Snapshot tests** con SnapshotTesting library:
- [[TodayView]] en estado vacío / parcial / completo
- [[OnboardingView]] cada paso
- [[CelebrationOverlayView]] frames clave
- [[InsightsView]] free vs pro
- Light + dark mode para cada uno

### UI Tests (target: critical paths)
**XCUITest** para:
- Onboarding completo (paso 1 → paso 6 → tab Today)
- Escribir primera gratitud → ver coach response
- Completar 3/3 → ver celebration → unlock extras
- Dark mode toggle persiste

## 🎯 Critical paths (priorizar)

### P0 (must)
1. Onboarding completion flow
2. Escribir y guardar gratitud
3. Streak increment al completar 3/3
4. App offline funciona

### P1 (should)
5. Trial start flow (cuando esté StoreKit real)
6. Filter history correctly
7. Weekly summary generation

### P2 (nice)
8. Difficult mode conversation
9. PDF export valid file
10. Smart notification scheduling

## 🛠️ Tooling propuesto

| Herramienta | Uso |
|---|---|
| XCTest | Unit + integration |
| XCUITest | UI tests |
| SnapshotTesting (PointFree) | Snapshot tests |
| ViewInspector | Test SwiftUI views internals |

## 📁 Organización

```
SereneTests/
├── Services/
│   ├── GratitudeServiceTests.swift
│   ├── PatternDetectionServiceTests.swift
│   └── ...
├── ViewModels/
│   ├── TodayViewModelTests.swift
│   └── ...
├── Models/
│   ├── StreakDataTests.swift
│   └── ...
└── Helpers/
    ├── MockURLProtocol.swift
    └── InMemoryContainer.swift

SereneUITests/
├── OnboardingFlowTests.swift
├── DailyFlowTests.swift
└── ...

SereneSnapshotTests/
├── TodayViewSnapshots.swift
├── OnboardingSnapshots.swift
└── ...
```

## 📈 Métricas objetivo

- Code coverage overall: 60%+
- Services coverage: 80%+
- ViewModels coverage: 70%+
- Critical paths UI tests: 100%

## 🚀 Plan de adopción

1. **Sprint 1**: Setup XCTest target, primeros 5 service tests (PatternDetection, Streak, Gratitude)
2. **Sprint 2**: ViewModel tests + más service tests
3. **Sprint 3**: Snapshot tests views críticas
4. **Sprint 4**: UI tests critical paths
5. **Continuous**: cada PR debe incluir tests para código nuevo

## 🔗 Relacionados
- [[Coding Standards]]
- [[Backlog]] (P1 item: test coverage inicial)
- [[Technical Debt]]
