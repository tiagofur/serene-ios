---
tags: [risks, register]
updated: 2026-04-14
---

# Risk Register

Riesgos identificados y mitigations.

## 🔴 Críticos (probabilidad × impacto alto)

### R1 — Crisis Detection no implementada
**Probabilidad**: Media
**Impacto**: Catastrófico (legal, ético, App Store rejection)
**Síntoma**: Usuario en crisis recibe respuesta inapropiada del coach
**Mitigation**:
- ✅ Disclaimer en onboarding (Serene NO es terapia)
- 🔴 **Implementar Crisis Detection antes de submit App Store**
- Documentar en [[AI Quality Goals]] sección Crisis Detection

**Estado**: Bloquea release. Ver [[Backlog]] P0.

### R2 — App Store review rechaza por wellness claims
**Probabilidad**: Media
**Impacto**: Alto (delay launch)
**Mitigation**:
- ✅ No hacer claims médicos en app/store listing
- ✅ Posicionamiento: bienestar y hábitos, NO terapia
- ✅ Disclaimer en onboarding
- ✅ Tier free completo (no pay-walled core)

**Estado**: Mitigado en diseño, validar en review.

## 🟠 Altos

### R3 — Retención baja (D1<50%)
**Probabilidad**: Alta
**Impacto**: Alto (model is broken)
**Mitigation**:
- ✅ [[Onboarding Flow]] termina con coach response
- ✅ [[Smart Notifications]] aprenden hora
- ✅ [[Streak Rescue]] reduce frustración
- ✅ Funciona offline
- 🟡 [[Re-engagement notifications]] pendiente

**Tracking**: Necesita [[AnalyticsService]] para validar

### R4 — Costes IA escalan inesperadamente
**Probabilidad**: Media
**Impacto**: Alto (margen)
**Mitigation**:
- ✅ Arquitectura híbrida (on-device para análisis)
- ✅ Cloud sólo para Pro y respuestas post-gratitud
- ✅ Free fallback local cálido
- 🟡 Backend metering por user (TODO)
- 🟡 Rate limiting (TODO)

**Estimación**: <$15/mes con 1000 Pro users. Ver [[Cost Model]].

### R5 — Competencia copia features rápido
**Probabilidad**: Alta
**Impacto**: Medio
**Mitigation**:
- Diferenciador es **tono + estética**, no features
- Apple-grade SwiftUI difícil de replicar bien
- Coach IA personalidad consistente requiere prompt engineering profundo
- Foco en LATAM/ES (Reflectly mainstream EN)

### R6 — Privacy breach de datos sensibles
**Probabilidad**: Baja
**Impacto**: Catastrófico
**Mitigation**:
- ✅ Encryption in transit (HTTPS)
- ✅ Keychain para tokens
- 🟡 SwiftData store con file protection (TODO)
- 🟡 Backend: encryption at rest, audit logs (responsabilidad backend)
- ✅ Mínimos datos enviados (no IP en payload)
- ✅ Retención logs 7 días en backend

## 🟡 Medios

### R7 — StoreKit 2 issues post-launch
**Probabilidad**: Media
**Impacto**: Medio
**Mitigation**:
- Testing exhaustivo en TestFlight con sandbox
- Receipt validation server-side
- Restore purchases path bien testeado
- Soporte para Family Sharing

### R8 — Calidad coach response inconsistente
**Probabilidad**: Media
**Impacto**: Medio
**Mitigation**:
- System prompt versionado
- Manual review semanal
- A/B testing prompts
- In-app feedback opcional

### R9 — Notificaciones percibidas como invasivas
**Probabilidad**: Baja
**Impacto**: Medio (uninstalls)
**Mitigation**:
- ✅ Max 2 notifications/día por design
- ✅ Interruption levels apropiados (passive vs timeSensitive)
- ✅ Permiso pedido en onboarding paso 5 con CTA secundario "Ahora no"
- ✅ Setting de hora customizable

## 🟢 Bajos

### R10 — SwiftData bugs en iOS 17.0-17.1
**Probabilidad**: Baja (con iOS 17.4+ minimum)
**Impacto**: Bajo
**Mitigation**: Ya seteado iOS 17+ minimum, sin predicates exóticos

### R11 — Apple deprecation de framework
**Probabilidad**: Baja en horizonte 2 años
**Impacto**: Medio
**Mitigation**: Stack es 100% nativo Apple, deprecations bien anunciadas

### R12 — Localization errors en LATAM (es-AR vs es-MX)
**Probabilidad**: Media cuando expandimos
**Impacto**: Bajo
**Mitigation**:
- Native review por país
- Glossary de términos sensibles
- Locale-specific strings cuando necesario

## 📊 Risk matrix

```
          Bajo Imp   Medio Imp   Alto Imp   Catastrófico
Alta P     R12        R5         R3              -
Media P    -          R7,R8      R2,R4           R1
Baja P     R10,R11    R9         -               R6
```

## 🔗 Relacionados
- [[Backlog]] (mitigations)
- [[AI Quality Goals]] (Crisis Detection)
- [[Security and Privacy]]
