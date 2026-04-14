---
tags: [architecture, offline, sync]
updated: 2026-04-14
---

# Offline-First Strategy

La app funciona completamente sin red. Backend es enriquecimiento, no requisito.

## 🎯 Principios

1. **Local primero**: Toda escritura va a SwiftData inmediatamente
2. **Network es opcional**: Si hay red, sync; si no, queue para después (futuro)
3. **AI fallback**: Cada servicio cloud tiene fallback local cálido
4. **UX nunca espera red**: Loading states son para typing animation, no para HTTP

## 🔄 Flujo de escritura

```
User taps "Guardar"
    ↓
GratitudeEntry insertado en ModelContext (sync, instant)
    ↓
context.save() persiste a SQLite
    ↓
[Async] POST /gratitudes (best-effort)
    ├── Success → entry.aiResponse = response.aiResponse
    └── Failure → entry.aiResponse = AICoachService.localFallback(...)
    ↓
ModelContext re-emit, UI updates con respuesta
```

Ver [[GratitudeService]] línea ~30.

## 🤖 AI Fallback Strategy

| Servicio | Cloud | Fallback Local |
|---|---|---|
| [[AICoachService]] | DeepSeek V3 / Gemini | 7 respuestas warm pre-escritas con `userName` |
| [[WeeklySummaryService]] | `/insights/weekly` | Template narrativo basado en topics + trend |
| [[DifficultModeService]] | `/ai/difficult-mode` | Árbol Socrático de 3 turnos |
| [[PatternDetectionService]] | (no cloud) | 100% on-device con `NLTagger` |

Cada uno usa `do/catch` alrededor de `APIService.request(...)` y retorna fallback en `catch`.

## 💾 Persistence Layer

```
SwiftData (@Model)
    ↓
ModelContainer (singleton, app lifetime)
    ↓
SQLite (default location)
```

**Backup**: iOS hace backup automático de SQLite via iCloud Backup (a menos que el usuario lo deshabilite). Los datos se restauran al reinstalar.

## 📡 Network detection

⚠️ **TODO**: No usamos `NWPathMonitor` actualmente. Cada request intenta y maneja error. Esto es OK pero puede mejorarse mostrando un indicador visual de "sin conexión".

## 🔁 Sync futuro (v2.0+)

### Estrategia propuesta
- Cada `@Model` tiene `id: UUID` y `createdAt: Date`
- Añadir campo `serverID: String?` y `syncedAt: Date?`
- Background task con `BGProcessingTask`:
  - Pull cambios desde `syncedAt` máximo
  - Push entries con `syncedAt == nil`
  - Conflict resolution: last-write-wins por `updatedAt` (a añadir)

### Conflictos
- iOS edit + servidor edit → server wins (timestamp más reciente)
- iOS delete + server still exists → soft delete (`deletedAt`)

⚠️ **TODO**: Implementar `[[Sync Engine]]` en [[v2.0]].

## 🔐 Encryption

| Capa | Estado |
|---|---|
| In transit | HTTPS via URLSession (default) |
| At rest local | iOS Data Protection (Class B mientras app esté abierta) |
| At rest server | Backend responsibility |

⚠️ **TODO**: Considerar `NSPersistentStoreFileProtectionKey = NSFileProtectionComplete` para SwiftData store cuando se establezca patrón.

## 🔗 Relacionados
- [[Tech Stack]]
- [[Data Models]]
- [[GratitudeService]]
- [[AICoachService]]
- [[ADR-004 - Offline-First]]
