---
tags: [metrics, retention]
updated: 2026-04-14
---

# Retention Strategy

Cómo logramos D1 50%+, D7 30%+, D30 20%+.

## 🎯 D1 (50%+)

**Estrategia**: La primera experiencia debe sentirse valiosa y completa.

### Tácticas
- ✅ [[Onboarding Flow]] termina con coach response (la magia)
- ✅ [[CelebrationOverlayView]] al completar primera 3/3
- ✅ Notificación al día siguiente en hora elegida
- ✅ App funciona offline (no friction de red)

### Riesgos
- Si onboarding paso 3 falla (escribir primera gratitud) → pérdida grande
- Si coach response es lenta o fea → no hay magia

## 🎯 D7 (30%+)

**Estrategia**: La semana 1 es donde el hábito se forma (o no).

### Tácticas
- ✅ [[Streak System]] visual con week dots
- ✅ [[Smart Notifications]] aprenden hora habitual
- ✅ [[Streak Protection]] notification a las 22:00 si tiene racha
- ✅ Día 7: [[Streak Milestones]] "Una semana"
- ✅ Resumen semanal Free disponible (lunes)

### Riesgos
- Sábado/domingo: usuarios cambian rutinas
- Si pierde día 4 sin rescue activo → drop-off alto

### Mejoras propuestas
- [[Smart weekend handling]] — notification time diferente Sab/Dom
- Re-engagement push si missed día 2-3

## 🎯 D30 (20%+)

**Estrategia**: Hábito establecido. Demostrar valor acumulado.

### Tácticas
- ✅ [[Activity Calendar]] visualiza progreso 30 días
- ✅ [[Streak Milestones]] 30 días → "Un mes contigo mismo"
- ✅ Pro: [[Pattern Detection]] empieza a generar insights
- ✅ Pro: [[Sentiment Chart]] muestra trend
- ✅ Free: 1 weekly summary recibido = touchpoint Pro

### Riesgos
- Después de mes 1, sin upgrade Pro, los insights son básicos
- Free content puede sentirse repetitivo

### Mejoras propuestas
- Push milestone día 21 ("3 semanas") — soft milestone
- Email "tu mes en gratitud" mensual con resumen

## 🎯 Long-term (M3+)

**Estrategia**: De hábito a parte de la identidad.

### Tácticas
- [[Pattern Detection]] connections más ricos
- [[Language Evolution]] muestra crecimiento personal
- 100 días milestone
- [[v2.1]]: Year in review

### Riesgos
- Saturación: misma mecánica diaria
- Necesidad de novedad sin destruir esencia

### Mejoras propuestas
- Modo voice ([[v2.0]]) como nueva modalidad
- Apple Watch integration ([[v2.1]])

## 🛡️ Anti-churn levers

### Para Free
- Banner en History con teaser Pro (sin ser invasivo)
- Insight Pro lockeado pero visible (FOMO controlado)

### Para Pro
- Difficult mode disponible cuando lo necesitas (rescata bad days)
- PDF export para llevar a terapia (uso real, no decorativo)
- Pattern insights se vuelven más personalizados con tiempo

## 📊 Funnel de retención

```
1000 downloads
   ↓
800 (80%) completan onboarding
   ↓
500 (50%) escriben día 2 — D1
   ↓
300 (30%) escriben día 7 — D7
   ↓
200 (20%) escriben día 30 — D30
   ↓
75 (7.5%) Pro suscriptores
```

(Números ilustrativos, ajustables con datos reales.)

## 🔬 Experimentos a correr

Una vez tengamos tracking ([[AnalyticsService]]):
- A/B test: notificación diaria copy variants
- A/B test: orden de pasos onboarding
- A/B test: timing del trial offer (paso 6 vs paso 5)
- Cohort analysis: trial converters vs no

## 🔗 Relacionados
- [[KPIs]]
- [[Smart Notifications]]
- [[Streak System]]
- [[Conversion Strategy]]
