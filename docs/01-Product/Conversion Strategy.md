---
tags: [product, monetization, conversion]
updated: 2026-04-14
---

# Conversion Strategy

Cómo convertimos a Free → Pro sin agresión.

## 🎯 Principio rector

> _"El usuario experimenta la magia ANTES de ver un precio."_

## 🪜 El embudo

```
Download
    ↓ (~95% completa)
Onboarding
    ↓ (la pantalla 4 es crítica)
Coach Response (la magia)
    ↓
Trial offer (paso 6)
    ├── Take trial    → Free Pro 14d → 15-18% conversion
    └── Skip trial    → Free user        → puede convertir más tarde
```

## 🔑 Touchpoints de conversión

### 1. Trial post-onboarding
Highest converter. Ya experimentaron magia.
- CTA principal: "Empezar 14 días gratis"
- CTA secundario: "Continuar con plan gratuito"
- Sin friction (no pide tarjeta)

### 2. History 7-day banner
Recordatorio gentil cuando intenta ver historial >7d.

### 3. Insights Pro section
Visible siempre para Free, lista features con lock icons.

### 4. Writing sheet difficult mode
Aparece pill rosa sólo para Pro. Free no lo ve, no genera FOMO directo (consciente).

### 5. Weekly summary 1/mes
Free recibe 1 al mes. Cuando intenta otro: "Próximo resumen disponible con Pro o el {date}"

## 🚫 Anti-patterns que evitamos

- ❌ Modal full-screen con paywall
- ❌ Interrumpir flow con "Upgrade now"
- ❌ Anuncios
- ❌ Dark patterns (auto-renew confuso)
- ❌ Shame language ("Solo Pro tiene historial completo, ¿no quieres saber?")

## 📊 Métricas a trackear

| Evento | Funnel step |
|---|---|
| `onboarding_started` | 1 |
| `onboarding_step_completed` (1-6) | 1.x |
| `trial_offered` | 2 |
| `trial_started` | 3 |
| `trial_to_paid` | 4 |
| `paid_renewed` | 5 |
| `paid_churned` | -- |

⚠️ **TODO**: Implementar analytics. Hoy no hay tracking.

## 🎁 Re-engagement (post-trial expired)

Si trial expira sin upgrade:
1. **Día 1 post-trial**: Notification "Vuelve a probar Pro 7 días gratis" (futuro)
2. **Mes 1**: Email de "tu resumen mensual de regalo" (futuro)
3. **Mes 3**: Re-trial 7 días con copy diferente

⚠️ **TODO**: Email service + re-engagement automation.

## 🎯 Conversion targets (PRD original)

| Métrica | Sector benchmark | Objetivo Serene |
|---|---|---|
| Trial start rate | 30-40% | 50%+ (sin friction) |
| Trial-to-paid | 10-15% | 15%+ (>18% goal) |
| Annual upgrade | 30% of paid | 40%+ (incentivo 42% off) |
| Churn mensual Pro | 5-8% | <5% (mejorar a <4%) |

## 🔗 Relacionados
- [[Monetization Model]]
- [[Onboarding Flow]]
- [[KPIs]]
- [[TrialOfferStepView]]
