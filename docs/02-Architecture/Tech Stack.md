---
tags: [architecture, tech-stack]
updated: 2026-04-14
---

# Tech Stack

Stack tecnológico completo del proyecto Serene.

## 📱 iOS App

| Capa | Tecnología | Versión | Notas |
|---|---|---|---|
| Lenguaje | Swift | 5.9+ | Strict concurrency mode futuro |
| UI Framework | SwiftUI | iOS 17+ | Declarative, no UIKit views |
| Persistencia | SwiftData | iOS 17+ | `@Model`, `@Query`, `ModelContainer` |
| State management | Combine + ObservableObject | — | `@Published`, `@StateObject`, `@EnvironmentObject` |
| Charts | Swift Charts | iOS 16+ | Sentiment chart |
| NLP | NaturalLanguage | iOS 17+ | `NLTagger` para sentiment on-device |
| Notifications | UserNotifications | iOS 17+ | UNCalendarNotificationTrigger |
| Storage credentials | Keychain Services | — | JWT token |
| PDF | PDFKit + UIGraphicsPDFRenderer | iOS 17+ | Export historial |
| Sharing | UIActivityViewController | iOS 17+ | PDF + image share |
| Iconos | SF Symbols | — | Sin assets custom |

## 🌐 Backend (Existente)

| Capa | Tecnología | Notas |
|---|---|---|
| Lenguaje | Go | Existente del equipo |
| HTTP | net/http o Gin | (a definir) |
| DB | PostgreSQL | Multi-tenant por user_id |
| Auth | JWT | Header `Authorization: Bearer` |
| Hosting | (a definir) | Posiblemente Fly.io / Render |

## 🤖 IA

### On-device (Free + Pro)
| Servicio | Uso | Coste |
|---|---|---|
| `NLTagger` | Sentiment scoring | $0 |
| Apple Intelligence (futuro) | Resúmenes locales | $0 |
| Core ML (futuro) | Topic detection | $0 |

### Cloud (mayoritariamente Pro)
| Servicio | Uso | Coste estimado |
|---|---|---|
| DeepSeek V3 o Gemini Flash | Coach response post-gratitud | $0.001/request |
| Mismo modelo | Weekly summary | $0.005/summary |
| Mismo modelo | Difficult mode chat | $0.002/turn |

**Total estimado**: <$0.005/usuario Pro/semana → **<$15/mes con 1,000 Pro users**

Ver [[Cost Model]] para detalles.

## 🎨 Fuentes

| Fuente | Uso | Origen |
|---|---|---|
| DM Serif Display | Headlines emocionales | Google Fonts |
| Plus Jakarta Sans | UI funcional | Google Fonts |

⚠️ **TODO**: Las fuentes deben incluirse en `Resources/Fonts/` y registrarse en `Info.plist > UIAppFonts`. Actualmente se usan fallbacks de sistema.

## 💳 Pagos

- **iOS**: StoreKit 2 con `Subscription` API
- **Android (futuro)**: Google Play Billing
- Productos:
  - `serene_pro_monthly` — $4.99/mes
  - `serene_pro_yearly` — $34.99/año (ahorro 42%)
- Trial: 14 días sin tarjeta obligatoria

⚠️ **TODO**: Integración real StoreKit. UI ya está pero sin transacción.

## 🛠️ Tooling

| Herramienta | Uso |
|---|---|
| Xcode 15+ | IDE principal |
| Git | Control de versiones (branch convention abajo) |
| GitHub | Hosting + PRs |
| Claude Code | Desarrollo asistido |

## 📦 Dependencias externas

**Ninguna** actualmente. Todo es framework nativo de Apple. Esta es una decisión deliberada (ver [[ADR-002 - Hybrid AI Architecture]]) para mantener:
- Mínimo footprint binario
- Cero supply chain risk
- Updates de OS sin friction

## 🔗 Relacionados
- [[Data Models]]
- [[Services Layer]]
- [[API Endpoints]]
- [[ADR-001 - SwiftData over CoreData]]
- [[ADR-002 - Hybrid AI Architecture]]
