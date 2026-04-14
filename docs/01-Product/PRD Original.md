---
tags: [product, prd, source-of-truth]
updated: 2026-04-14
---

# PRD Original

Documento Product Requirements Document fuente. Vive en `/PRD/` (no en este vault para preservarlo intacto).

## 📁 Archivos del PRD

| Archivo | Contenido |
|---|---|
| `PRD/README.md` | Índice principal |
| `PRD/01-vision-producto.md` | Visión, propuesta de valor, mecánica core |
| `PRD/02-funcionalidades.md` | Features, coach IA, gamificación, insights |
| `PRD/03-monetizacion.md` | Modelo freemium, conversión |
| `PRD/04-sistema-diseno.md` | Paleta, tipografía, espaciado |
| `PRD/05-pantallas-navegacion.md` | Arquitectura pantallas, flujos |
| `PRD/06-stack-tecnico.md` | Stack, modelo datos, endpoints |
| `PRD/07-roadmap-metricas.md` | Roadmap, KPIs, riesgos |

## 🎯 Cuándo consultar el PRD

- **Decisiones de producto**: ¿este feature es alineado con la visión?
- **Validación de comportamiento**: ¿la UI cumple specs PRD?
- **Disputas de tono**: ¿cómo debe responder el coach en X?
- **Roadmap dudas**: ¿qué venía después de v1.x?

## 🔄 Cuándo actualizar este vault vs PRD

- **Vault** (`docs/`): Documenta el "qué se construyó" y "cómo se construyó"
- **PRD** (`/PRD/`): Documenta el "qué queremos construir" y "por qué"

Si cambia el plan: actualizar PRD primero, luego propagar al vault.

## 📊 Mapeo PRD → Vault

| Sección PRD | Doc en vault |
|---|---|
| §1 Visión | [[Vision]] |
| §2 Mecánica 3+2 | [[3+2 Mechanic]] |
| §3.1 Registro de gratitudes | [[3+2 Mechanic]] + [[GratitudeEntry]] |
| §3.2 Coach IA | [[AI Coach]] + [[AICoachService]] |
| §3.3 Racha | [[Streak System]] |
| §3.4 Weekly summary | [[Weekly Summary]] |
| §3.5 Insights Pro | [[Pattern Detection]] + sub-features |
| §4 Monetización | [[Monetization Model]] + [[Conversion Strategy]] |
| §5 Diseño | [[Design System]] + [[Color Tokens]] + [[Typography]] |
| §6 Navegación | [[Screen Inventory]] + [[Onboarding Flow]] |
| §7 Pantallas spec | Cada [[..View]] doc |
| §8 Stack técnico | [[Tech Stack]] + [[Data Models]] + [[API Endpoints]] |
| §9 Roadmap | [[MOC - Roadmap]] + [[Changelog]] |
| §10 Métricas | [[KPIs]] + [[Retention Strategy]] |
| §11 Riesgos | [[Risk Register]] |

## 🔗 Relacionados
- [[README]] (de este vault)
- [[MOC - Product]]
