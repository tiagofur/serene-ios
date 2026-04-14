---
tags: [feature, ai, coach]
status: completed
version_introduced: 1.0
tier: free
---

# AI Coach

Respuesta personalizada del coach **inline** debajo de cada gratitud.

## 🎯 Comportamiento

1. User escribe gratitud → tap "Guardar"
2. Aparecen typing dots animados (3 puntos, 350ms cycle)
3. Respuesta aparece **character by character** a 28ms/char
4. Permanece visible inline en el slot (no navega a otra screen)
5. Al cerrar sheet, se ve en el slot completado

## 🤖 Cómo se genera

- **Cloud (preferido)**: [[AICoachService]] llama `POST /ai/coach`
- **Local fallback**: 7 plantillas pre-escritas con `userName`

Ver [[AICoachService]] para detalle.

## 🎨 Visual

[[CoachReplyView]]:
- Avatar 20×20 sage circle con `sparkle` icon
- Bubble: sage soft fill, radius 10
- Padding 8-12px
- Body 14pt en texto secundario

## 📝 Reglas de tono (PRD §3.2)

> _"La IA no es un chatbot generico. Lee las gratitudes del usuario, recuerda sus temas recurrentes y responde en tono de coach que lo conoce. Nunca da consejos no solicitados. Valida primero, sugiere despues. Usa el nombre del usuario con frecuencia."_

### Reglas verificables
- ✅ Máximo 2 frases
- ✅ Incluir `userName`
- ✅ Validar antes de cualquier sugerencia
- ✅ Emoji al final cuando apropiado
- ❌ Nunca consejos médicos
- ❌ Nunca preguntas que requieran respuesta

## ⏱️ Latencia objetivo

| Métrica | Target | Real (TBD) |
|---|---|---|
| Cloud response time | <3s | TBD con backend |
| Local fallback time | <100ms | ✅ instant |
| Typing animation | 28ms/char | ✅ |

## 🔗 En onboarding

[[CoachResponseStepView]] (paso 4/6) — **la pantalla más importante** según PRD. Es el primer momento en que el usuario "siente la magia" antes de cualquier paywall.

## 🔗 Relacionados
- [[AICoachService]]
- [[CoachReplyView]]
- [[Difficult Mode]] (variante conversacional)
- [[AI Architecture]]
- [[Onboarding Flow]]
