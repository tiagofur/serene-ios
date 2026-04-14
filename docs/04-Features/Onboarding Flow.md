---
tags: [feature, onboarding, critical]
status: completed
version_introduced: 1.0
---

# Onboarding Flow

6 pasos que terminan con el usuario sintiendo "la magia" antes de cualquier paywall.

## 🎯 Regla crítica del PRD

> _"La pantalla 4 (Respuesta del coach) debe ejecutarse ANTES de cualquier menu de suscripcion. El usuario necesita experimentar el valor diferencial de Serene antes de ver un precio. Esta secuencia no debe modificarse."_

## 📋 Los 6 pasos

| # | Pantalla | Objetivo | Duración | Critical |
|---|---|---|---|---|
| 1 | [[WelcomeStepView]] | Capturar nombre + estado emocional | 20s | |
| 2 | [[ScienceStepView]] | Credibilidad: la ciencia de la gratitud | 30s | |
| 3 | [[FirstGratitudeStepView]] | Escribir primera gratitud | 60s | |
| 4 | [[CoachResponseStepView]] | El coach responde personalizado | 30s | ⭐⭐⭐ |
| 5 | [[ReminderStepView]] | Configurar hora del ritual | 15s | |
| 6 | [[TrialOfferStepView]] | Trial Pro sin presión | 20s | |

**Total estimado**: ~3 minutos

## 🎨 Detalles por paso

### 1. Welcome (Bienvenida)
- Title: "Bienvenido a Serene"
- Input: nombre del usuario (TextField)
- Mood selector: 5 emojis (😊😐😔😤😴) con labels
- CTA: "Continuar" (disabled si no hay nombre)

### 2. Science (Ciencia)
- Title: "La ciencia detrás de la gratitud"
- 3 benefits cards animados con stagger:
  - Reduce ansiedad 23% (UC Davis)
  - Mejora calidad sueño (Emmons & McCullough)
  - Fortalece relaciones (Seligman)
- Preview de mecánica 3+2 con checks/stars
- CTA: "Empezar mi primer momento"

### 3. First Gratitude (Primera gratitud)
- Title: "Tu primera gratitud"
- Subtitle calmante: "No tiene que ser algo grande..."
- Mood selector inline
- TextEditor focusable
- CTA: "Guardar mi gratitud"
- Loading state: "Tu coach está pensando..." con ProgressView
- Auto-advance al paso 4 cuando llega respuesta

### 4. Coach Response ⭐ (LA CRÍTICA)
- Avatar coach grande sage
- Title con animación fade-in: "Tu coach ha leído tu gratitud"
- Echo de lo que el user escribió
- Coach response **character-by-character** (28ms/char)
- Botón "Continuar" aparece **después** de typing termina

> Esta pantalla es el argumento de venta. Si funciona aquí, funciona para conversión.

### 5. Reminder
- Icon arena bell
- Title: "Tu ritual diario"
- Wheel DatePicker para hour:minute
- Quick buttons: Mañana 8:00, Mediodía 13:00, Noche 21:00
- CTA principal: "Activar recordatorio" → solicita permission
- CTA secundario: "Ahora no" (siempre visible)

### 6. Trial Offer
- Crown badge arena
- Title: "Lleva tu gratitud al siguiente nivel"
- 4 features Pro animados con stagger
- Pricing claro: $4.99/mes o $34.99/año (ahorra 42%)
- CTA principal: "Empezar 14 días gratis"
- CTA secundario: **"Continuar con plan gratuito"** (NUNCA "Skip" u "Omitir")

## 📐 Progress bar

Top bar de 3px width. Sage fill animado al 1/6, 2/6, 3/6, 4/6, 5/6, 6/6.

## 🎯 Conversion strategy

Per PRD: _"El gancho de conversion NO es un paywall agresivo. Es que el usuario experimente la magia del coach personalizado ANTES de que le pidamos dinero."_

**Objetivos**:
- Trial-to-paid: >15% (estándar 10-15%)
- Churn mensual Pro: <5%

## 🔗 Implementación

- View: [[OnboardingView]] (TabView indexed)
- VM: [[OnboardingViewModel]]
- 6 step views en `Views/Onboarding/`
- Trigger: `@AppStorage("hasCompletedOnboarding")` flag

## 🔗 Relacionados
- [[Vision]]
- [[AI Coach]]
- [[Monetization Model]]
- [[Conversion Strategy]]
