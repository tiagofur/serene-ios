---
tags: [moc, home, index]
created: 2026-04-14
updated: 2026-04-14
status: active
---

# Serene — Documentation Vault

> **Daily Gratitude & AI Wellness Coach**
> iOS-first · SwiftUI · Go Backend

Esta es la documentación completa del proyecto Serene organizada como un vault de Obsidian. Toda información sobre el producto, arquitectura, código, features, roadmap y decisiones vive aquí.

---

## 🗺️ Mapas de Contenido (MOCs)

- [[MOC - Product]] — Visión, features, monetización, diseño
- [[MOC - Architecture]] — Stack técnico, arquitectura, decisiones
- [[MOC - Codebase]] — Estructura del código, servicios, views
- [[MOC - Features]] — Todas las features implementadas
- [[MOC - Roadmap]] — Historia de versiones + plan futuro
- [[MOC - Development]] — Guías para desarrolladores

---

## 📊 Estado del Proyecto

| Métrica | Valor |
|---|---|
| **Versión actual** | v1.2 (completada) |
| **Siguiente versión** | [[v2.0]] (planificada) |
| **Plataforma** | iOS 17+ |
| **Lenguaje** | Swift 5.9 + SwiftUI |
| **Archivos Swift** | 51 |
| **Branch principal** | `claude/implement-prd-features-ooe2m` |

### Versiones

- [[v1.0 MVP]] ✅ — Pantalla Hoy, sheet escritura, coach IA, racha, onboarding 6 pasos, StoreKit
- [[v1.1]] ✅ — Resumen semanal, notificaciones inteligentes, rescate de racha, modo oscuro pulido
- [[v1.2]] ✅ — Patrones emocionales, modo difícil, exportar PDF, gráfica de sentimiento
- [[v2.0]] 🔜 — Dictado por voz, widget iOS, Android Jetpack Compose, PT-BR
- [[v2.1]] 🔮 — Gratitud relacional, HealthKit, modo familia

---

## 🎯 Referencias Rápidas

### Producto
- [[Vision]] — Propuesta de valor
- [[Features Overview]] — Todas las funcionalidades
- [[Monetization Model]] — Free vs Pro
- [[Design System]] — Paleta, tipografía, espaciado
- [[User Personas]] — Usuario objetivo

### Arquitectura
- [[Tech Stack]] — Tecnologías usadas
- [[Data Models]] — SwiftData models
- [[Services Layer]] — Servicios de negocio
- [[API Endpoints]] — Backend Go
- [[Offline-First Strategy]]

### Features principales
- [[3+2 Mechanic]] — Core del producto
- [[AI Coach]] — Respuestas personalizadas
- [[Streak System]] — Racha + rescate + hitos
- [[Weekly Summary]] — Resumen narrativo semanal
- [[Smart Notifications]] — Aprende hora habitual
- [[Difficult Mode]] — Coach conversacional
- [[PDF Export]] — Exportar historial
- [[Pattern Detection]] — Conexiones inesperadas

### Desarrollo
- [[Getting Started]] — Setup del proyecto
- [[Coding Standards]]
- [[Git Workflow]]
- [[Testing Strategy]]

---

## 📁 Estructura del Vault

```
docs/
├── 00-Index/              ← Mapas de contenido (MOCs)
├── 01-Product/            ← Documentación de producto
├── 02-Architecture/       ← Arquitectura técnica + ADRs
├── 03-Codebase/           ← Documentación de código
│   ├── Services/
│   ├── Views/
│   └── Models/
├── 04-Features/           ← Una nota por feature
├── 05-Development/        ← Guías de desarrollo
├── 06-Roadmap/            ← Historial y plan de versiones
├── 07-Metrics/            ← KPIs y objetivos
├── 08-Risks/              ← Registro de riesgos
├── 09-Backlog/            ← Tareas pendientes, deuda técnica
└── 10-Assets/             ← Imágenes, mockups, diagramas
```

---

## 🏷️ Tags Convention

- `#moc` — Map of Content (índices)
- `#feature` — Documentación de feature
- `#service` — Documentación de servicio
- `#view` — Documentación de vista
- `#adr` — Architecture Decision Record
- `#roadmap` — Planes de versión
- `#backlog` — Tareas pendientes
- `#risk` — Riesgo identificado
- `#status/completed` · `#status/in-progress` · `#status/planned`

---

## 🔗 Enlaces Externos

- [[PRD Original]] — Documentación original del PRD (carpeta `/PRD`)
- Repo: `tiagofur/serene-ios`
- Branch: `claude/implement-prd-features-ooe2m`

---

_Última actualización: 2026-04-14 · Mantenido como parte del proyecto_
