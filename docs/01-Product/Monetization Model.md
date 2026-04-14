---
tags: [product, monetization, business]
updated: 2026-04-14
---

# Monetization Model

Freemium con suscripción Pro. Estrategia: **valor antes que paywall**.

## 💰 Pricing

| Tier | Precio | Trial |
|---|---|---|
| Free | $0 | — |
| Pro Monthly | $4.99/mes | 14 días sin tarjeta |
| Pro Yearly | $34.99/año (ahorra 42%) | 14 días sin tarjeta |

## 📊 Free vs Pro

| Feature | Free | Pro |
|---|---|---|
| Gratitudes diarias | 3 base | 3 base + 2 extras |
| Respuesta coach | ✅ con cada gratitud | ✅ con mayor contexto |
| Historial | 7 días | Ilimitado |
| Resumen IA | 1 mensual | Semanal + histórico |
| [[Pattern Detection]] | — | ✅ Semanal |
| [[Difficult Mode]] | — | ✅ |
| [[Sentiment Chart]] | — | ✅ |
| [[Unexpected Connections]] | — | ✅ |
| [[Language Evolution]] | — | ✅ Mensual |
| [[PDF Export]] | — | ✅ |
| Sin publicidad | ✅ | ✅ |

> Nota: Los **extras 4-5** del 3+2 son técnicamente Free según PRD original, pero son funcionalmente unlock dentro de la mecánica (no Pro feature).

## 🎯 Estrategia de conversión

Per PRD: _"El gancho de conversion NO es un paywall agresivo. Es que el usuario experimente la magia del coach personalizado ANTES de que le pidamos dinero."_

### Touchpoints de conversión

1. **Onboarding paso 6** ([[TrialOfferStepView]]): Trial offer post-coach response
2. **History view**: Banner "Historial completo con Pro"
3. **Insights view**: Sección Pro locked con preview features
4. **Writing sheet**: "No encuentro nada hoy" mostrado como hint Pro

### CTA secundario siempre visible
- Onboarding: "Continuar con plan gratuito"
- Profile: "Probar 14 días gratis"
- Banners: removibles, sin shame

## 📈 Objetivos

| Métrica | Mes 1 | Mes 3 | Mes 6 |
|---|---|---|---|
| MRR | $0 | $500 | $2,500 |
| Trial-to-paid | — | 15%+ | 18%+ |
| Churn mensual Pro | — | <5% | <4% |
| ARPU | — | $4.20 | $4.50 |
| Usuarios activos mensuales | 100 | 500 | 2,000 |

Ver [[KPIs]] para detalle completo.

## 🔧 Implementación

### StoreKit 2
**Estado actual**: UI implementada, transacción real **pendiente**.

⚠️ **TODO**:
- Configurar productos en App Store Connect
- Implementar `Transaction.updates` listener
- Receipt validation server-side
- Family sharing support

### Backend
- `POST /subscriptions/trial` — start trial
- `GET /subscriptions/status` — verify tier
- `POST /subscriptions/restore` — restore purchases

Ver [[API Endpoints]].

## 🌍 Pricing por país (futuro)

App Store Connect permite tiers regionales. Posibles ajustes:
- LATAM: $2.99/$19.99 (paridad poder adquisitivo)
- Brasil: R$14.99/R$99.99
- Europa: €4.99/€34.99 (mantener)

## ❌ Lo que NO haremos

- ❌ Anuncios — destruirían el tono
- ❌ Venta de datos
- ❌ Lifetime price (induces churn predictability worse)
- ❌ Bundle con otras apps (Reflectly intentó esto, falló)

## 🔗 Relacionados
- [[Vision]]
- [[Conversion Strategy]]
- [[KPIs]]
- [[Onboarding Flow]]
- [[TrialOfferStepView]]
