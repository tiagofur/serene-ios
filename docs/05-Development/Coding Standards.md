---
tags: [development, standards]
updated: 2026-04-14
---

# Coding Standards

Convenciones Swift + SwiftUI para el proyecto.

## 🎯 Principios

1. **Legibilidad > brevedad**: prefer claro a clever
2. **SwiftUI idiomático**: aprovecha `@Query`, `@StateObject`, modifiers chain
3. **Sin dependencias externas** sin discusión previa
4. **Marcas `// MARK:`** para navegación

## 📁 Naming

### Files
- `PascalCase.swift`
- View: `<Name>View.swift`
- ViewModel: `<Name>ViewModel.swift`
- Service: `<Name>Service.swift`
- Modelo SwiftData: `<Name>.swift` (sin sufijo)

### Symbols
- Tipos: `PascalCase`
- Vars/funcs: `camelCase`
- Enums: cases en `camelCase`
- Constants: `static let` en `camelCase`

### Boolean naming
- `is...`, `has...`, `can...`, `should...`
- ✅ `isCompleted`, `canRescue`, `shouldGenerateSummary`
- ❌ `completed`, `rescue`, `generateSummary`

## 🏛️ Estructura de archivo

### View
```swift
import SwiftUI

struct FeatureView: View {
    // MARK: - Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext

    // MARK: - State
    @StateObject private var viewModel = FeatureViewModel()
    @State private var showSheet = false

    // MARK: - Body
    var body: some View {
        // ...
    }

    // MARK: - Subviews
    private var headerSection: some View {
        // ...
    }

    // MARK: - Helpers
    private func formatDate(_ date: Date) -> String {
        // ...
    }
}

#Preview {
    FeatureView()
}
```

### ViewModel
```swift
import SwiftUI
import SwiftData
import Combine

@MainActor
final class FeatureViewModel: ObservableObject {
    // MARK: - Published State
    @Published var data: [Item] = []
    @Published var isLoading = false

    // MARK: - Computed
    var hasData: Bool { !data.isEmpty }

    // MARK: - Data Operations
    func loadData(context: ModelContext) { /*...*/ }

    // MARK: - User Actions
    func onTap() async { /*...*/ }
}
```

### Service
```swift
import Foundation

final class FeatureService {
    static let shared = FeatureService()
    private init() {}

    // MARK: - Public API
    func doSomething() async throws -> Result { /*...*/ }

    // MARK: - Private helpers
    private func internal() { /*...*/ }
}
```

## 🎨 SwiftUI Patterns

### Color usage
**SIEMPRE** vía `SereneColors`:
```swift
.foregroundColor(SereneColors.textPrimary(colorScheme))
.background(SereneColors.surface(colorScheme))
```

❌ NUNCA hardcodear:
```swift
.foregroundColor(.black)        // BAD
.foregroundColor(Color(hex: "#2D2420"))  // BAD
```

### Spacing
**SIEMPRE** vía tokens:
```swift
.padding(Spacing.md)
.frame(width: 40, height: 40)
VStack(spacing: Spacing.lg) { ... }
```

### Typography
**SIEMPRE** vía helpers:
```swift
.sereneBody()
.sereneHeading(20)
.sereneSectionHeader()
```

### Conditionals en body
Pequeños: inline ternary
```swift
.foregroundColor(isActive ? SereneColors.sage(colorScheme) : SereneColors.textTertiary(colorScheme))
```

Grandes: extraer a `private var`
```swift
private var slotBackground: some View {
    Group {
        switch state {
        case .done: ...
        case .empty: ...
        }
    }
}
```

### Async work
- ViewModels: `@MainActor` + `async/await`
- Services: pueden ser nonisolated, pero VMs deben llamarlos desde MainActor
- `Task { ... }` en `.onAppear` o `.task { ... }` (preferir `.task`)

### Sheets/Modals
```swift
.sheet(isPresented: $showSheet) {
    SomeSheet()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
}
```

## 📝 Comments

### Cuando comentar
- ✅ Por qué (no qué) cuando no es obvio
- ✅ TODO con contexto: `// TODO: handle X when v2.0 launches`
- ✅ MARK para navegación
- ✅ Doc comments en API pública (`///`)

### Cuando NO comentar
- ❌ Lo que el código ya dice
- ❌ Comentarios desactualizados (peor que ninguno)
- ❌ Bloques // MARK: dentro de funciones

## ⚠️ Anti-patterns a evitar

- ❌ `print()` en producción → usar `LoggingService` (TODO)
- ❌ Force unwraps `!` excepto en SwiftUI body cuando es seguro
- ❌ String literals para keys (UserDefaults, Notification names) — usar enum
- ❌ Massive views (>200 lines) — extraer subviews
- ❌ Nested ternaries
- ❌ TODO sin contexto/owner

## 🧪 Testing standards

(Cuando empecemos a tener tests)
- Test files: `<Name>Tests.swift`
- Estructura: AAA (Arrange / Act / Assert)
- Mocks: protocols + fakes
- Snapshot tests para views complejas

## 🔗 Relacionados
- [[Getting Started]]
- [[Git Workflow]]
- [[File Structure]]
- [[ADR-003 - MVVM Pattern]]
