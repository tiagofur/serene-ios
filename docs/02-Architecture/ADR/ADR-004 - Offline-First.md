---
tags: [adr, architecture, offline, accepted]
adr_number: 004
status: accepted
date: 2026-04-14
---

# ADR-004 — Offline-First

## Status
**Accepted** · 2026-04-14

## Contexto
Una app de gratitud debe funcionar:
- En el avión
- En el subway
- En zonas con mala conectividad
- Sin requerir login en cada apertura

Si la app falla cuando no hay red, el hábito se rompe en momentos de fricción.

## Decisión

**Local primero. Cloud opcional.**

### Reglas
1. Cada `POST` escribe primero a SwiftData, luego intenta network
2. Si network falla: silenciosamente cae a fallback local
3. Cada feature de IA tiene fallback local cálido (ver [[AI Architecture]])
4. UI nunca espera por network (loading states son para typing animation)
5. Los datos persisten incluso sin auth (auth es opcional para uso básico)

## Consecuencias

### Positivas
- ✅ App funciona en cualquier escenario de conectividad
- ✅ Hábito no se rompe por falla técnica
- ✅ UX siente "instantánea"
- ✅ Backup iCloud automático del SQLite

### Negativas
- ❌ Sync explícito requerido (TODO [[v2.0]])
- ❌ Posibles conflictos cuando se reconecta
- ❌ Más código (cada feature dual-path)

### Mitigations
- [[GratitudeService]] documenta el offline flow
- Tests deben cubrir offline path
- En [[v2.0]] implementar [[Sync Engine]] formal

## Implementación actual

### Escritura
```swift
// In GratitudeService
func saveGratitude(...) async -> GratitudeEntry {
    // 1. Local first
    let entry = GratitudeEntry(...)
    context.insert(entry)

    // 2. Cloud best-effort
    do {
        let response = try await APIService.shared.request(...)
        entry.aiResponse = response.aiResponse
    } catch {
        // Silent fallback — entry already saved
        print("Offline: \(error)")
    }

    return entry
}
```

### Lectura
- 100% local via `@Query` en SwiftUI
- No hay `loading` state porque data está siempre disponible

## Sync futuro

Ver [[Offline-First Strategy]] sección "Sync futuro".

Estrategia propuesta:
- `serverID: String?` y `syncedAt: Date?` en cada modelo
- Background sync con `BGProcessingTask`
- Conflict resolution: last-write-wins
- En [[v2.0]] launch

## 🔗 Relacionados
- [[Offline-First Strategy]]
- [[GratitudeService]]
- [[AI Architecture]]
- [[Data Models]]
