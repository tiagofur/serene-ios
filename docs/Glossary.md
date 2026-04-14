---
tags: [glossary, reference]
updated: 2026-04-14
---

# Glosario

Términos del producto y código.

## A

**ADR** — Architecture Decision Record. Documento corto que captura una decisión técnica importante con contexto y consecuencias. Ver `docs/02-Architecture/ADR/`.

**AI Coach** — La voz de IA que responde a las gratitudes del usuario. Ver [[AI Coach]].

**Apple Intelligence** — Suite on-device LLM de Apple (iOS 18+). Considerado para [[v2.0]].

**ARPU** — Average Revenue Per User. Métrica clave de monetización.

## B

**Baseline (sentiment)** — Promedio de sentiment scores en window de 30 días. Usado para detectar lift en [[Pattern Detection]].

## C

**Cloud (en context AI)** — Llamada a backend Go que invoca DeepSeek/Gemini. Vs on-device.

**Connections (emocionales)** — Topics que mejoran tu sentiment promedio. Ver [[Unexpected Connections]].

**Coach** — Persona de IA que acompaña al usuario. Sinónimos contextuales: "tu coach", "tu acompañante".

**Crisis Detection** — Sistema que detecta señales de crisis emocional y redirige a recursos. Ver [[AI Quality Goals]].

**Cristalizar (gratitud)** — En [[Difficult Mode]], cuando el coach reformula lo que dijo el usuario como gratitud explícita.

## D

**Difficult Mode** — Coach conversacional cuando user no encuentra qué agradecer. Pro feature. Ver [[Difficult Mode]].

**DM Serif Display** — Fuente serif para momentos emocionales del producto. Ver [[Design System]].

## E

**Emoji mood** — Selector de 5 estados emocionales (😊🙏😌❤️🤔) en [[GratitudeEntry]].

**Extras (slots 4-5)** — Slots desbloqueados después de completar 3 base. Ver [[3+2 Mechanic]].

**Expansion count** — Cantidad de palabras nuevas únicas en window actual vs anterior. Ver [[Language Evolution]].

## F

**Fading words** — Palabras frecuentes hace 30-60 días, raras hoy. Ver [[Language Evolution]].

**Free tier** — Plan gratuito sin suscripción. Ver [[Monetization Model]].

## G

**Gratitude slot** — Cada uno de los 5 espacios diarios donde escribir. Estados: empty, active, done, extraLocked, extraUnlocked.

## H

**Hito** — Milestone (7, 30, 100 días de racha). Ver [[Streak Milestones]].

**Hour habitual** — Hora del día más frecuente en que el usuario escribe gratitudes. Detectada en [[SmartNotificationService]].

## I

**Insights** — Tab 3 de la app. Análisis y patrones. Ver [[InsightsView]].

## L

**Language Evolution** — Análisis de cambio de vocabulario 30d vs 60d. Ver [[Language Evolution]].

**Lift (sentiment)** — Diferencia entre sentiment de un topic vs baseline. Threshold significativo: 0.08.

## M

**MOC** — Map of Content. Notas tipo índice en este vault. Ver `docs/00-Index/`.

**MRR** — Monthly Recurring Revenue. Métrica clave de SaaS.

## N

**Nudge** — Notificación soft, baja prioridad, designed to remind without pressure. Ver [[Smart Notifications]].

**NLTagger** — Clase de framework `NaturalLanguage` para sentiment scoring on-device. Ver [[ADR-005 - Natural Language for Sentiment]].

## O

**Offline-first** — Estrategia: local primero, network es bonus. Ver [[Offline-First Strategy]].

**Onboarding** — 6 pantallas al primer launch. Ver [[Onboarding Flow]].

**On-device** — Análisis que ocurre sin red, en el iPhone. Vs cloud.

## P

**Pattern (snapshot)** — Detección serializada como [[PatternEntry]]. Hoy solo type=`connection`.

**Plus Jakarta Sans** — Fuente sans-serif para UI funcional. Ver [[Design System]].

**Pro** — Plan de suscripción. $4.99/mes o $34.99/año. Ver [[Monetization Model]].

**Prompt** — Texto que invita al usuario a escribir. Ej: "Hoy agradezco...", "¿Qué te sorprendió?".

## R

**Racha** — Streak. Días consecutivos con gratitudes completadas. Ver [[Streak System]].

**Rescate (de racha)** — Mecanismo para recuperar una racha perdida. 1x/mes. Ver [[Streak Rescue]].

## S

**Sage** — Color principal del producto (`#5A7A6B` light, `#8BBCA8` dark). Ver [[Color Tokens]].

**Sentiment score** — Valor [0, 1] del tono emocional. Generado por [[NLTagger]] o cloud.

**Sentiment trend** — `ascending` / `stable` / `reflective`. Categoría calculada para [[Weekly Summary]].

**Slot** — Ver "Gratitude slot".

**Smart nudge** — Notificación que aparece 15 min antes de la hora habitual del usuario. Ver [[Smart Notifications]].

**Streak protection** — Notificación a las 22:00 si user con racha ≥3 no escribió. Ver [[Smart Notifications]].

**SwiftData** — Framework de persistencia de Apple (iOS 17+). Ver [[ADR-001 - SwiftData over CoreData]].

## T

**Tier** — Plan del usuario: `free` o `pro`. Stored en `UserProfile.tier`.

**Tierra orgánica** — Estética del producto: cálida, natural, no clínica. Ver [[Design System]].

**Top topics** — 3 palabras más frecuentes en gratitudes. Mostradas en [[InsightsView]] y [[Weekly Summary]].

**Trial** — 14 días Pro gratis sin tarjeta. Ver [[Monetization Model]].

## U

**Unlock** — Momento en que se desbloquean los 2 extras al completar 3/3. Disparado por [[CelebrationOverlayView]].

## V

**ViewModel** — Clase `@MainActor ObservableObject` que maneja estado y lógica de una view. Ver [[ADR-003 - MVVM Pattern]].

## W

**Week dots** — 7 indicadores visuales en [[StreakCardView]] mostrando estado del día (done/today/empty).

**Weekly Summary** — Narrativa generada cada lunes. Ver [[Weekly Summary]].

## 🔗 Relacionados
- [[README]]
- [[MOC - Product]]
- [[MOC - Codebase]]
