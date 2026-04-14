---
tags: [adr, architecture, accepted]
adr_number: 001
status: accepted
date: 2026-04-14
deciders: [equipo-iOS]
---

# ADR-001 — SwiftData over CoreData

## Status
**Accepted** · 2026-04-14

## Contexto
Necesitamos persistencia local para gratitudes, racha, perfil, resúmenes, patterns. La app es iOS 17+ exclusivo. Tres opciones:

1. **CoreData**: Maduro, complejo, mucha boilerplate
2. **SwiftData**: Nuevo (iOS 17+), declarativo, integración nativa con SwiftUI
3. **Realm o GRDB**: Third-party, añade dependencia

## Decisión
Usamos **SwiftData** con `@Model` macro.

## Consecuencias

### Positivas
- ✅ Cero boilerplate vs CoreData
- ✅ `@Query` en SwiftUI views es declarativo y reactivo
- ✅ Type-safe con macros, no `NSManagedObject` casting
- ✅ Sin dependencias externas
- ✅ Migrations automáticas para cambios simples
- ✅ Underlying SQLite es battle-tested

### Negativas
- ❌ iOS 17+ obligatorio (descarta ~5% del mercado al lanzar)
- ❌ Algunos bugs en iOS 17.0-17.1 (handle predicates complejas)
- ❌ Menos recursos de aprendizaje vs CoreData
- ❌ Migrations de schema complejas requieren `SchemaMigrationPlan` aún experimental

### Neutras
- ⚪ Tenemos que usar `#Predicate<T>` en lugar de `NSPredicate`
- ⚪ Threading: `@MainActor` en VMs que tocan `ModelContext`

## Alternativas consideradas

### CoreData
Rechazado por verbosidad y poca afinidad con SwiftUI. Habría duplicado código.

### Realm
Rechazado por: dependencia externa, posibles binary size impacts, less Apple-native.

## Notas
- Migration paths futuros documentados en cada `@Model`
- En [[v2.0]] cuando salgamos a Android, SwiftData no será compartible. Se evaluará entonces si KMP + SQLDelight es mejor para shared logic.

## 🔗 Relacionados
- [[Data Models]]
- [[Tech Stack]]
- [[Offline-First Strategy]]
