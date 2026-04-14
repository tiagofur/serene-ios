---
tags: [feature, ai, pro, difficult-mode]
status: completed
version_introduced: 1.2
tier: pro
---

# Difficult Mode

Coach conversacional para días en que no encuentras nada que agradecer. Pro feature.

## 🎯 Cuándo se activa

Trigger en [[WritingSheetView]] (solo Pro):
- Píldora "No encuentro nada hoy" en color rosa
- Tap → abre [[DifficultModeView]] como sheet

## 💬 Cómo funciona

### 1. Opening (cálido, sin presión)
> _"Hola María, algunos días nos encuentran vacíos. Está bien. No tienes que forzar nada. Solo respirá un momento conmigo. ¿Cómo te sientes ahora mismo?"_

### 2. Conversación Socrática
El coach guía con **3 turnos**:
- **Turn 1**: Validar + redirigir al cuerpo
- **Turn 2**: Buscar micro-momentos (luz, calor, espacio)
- **Turn 3**: Cristalizar lo dicho como gratitud

### 3. Suggestion Card
Cuando coach detecta candidato, aparece tarjeta arena con:
```
✨ Posible gratitud
"Hoy agradezco [reformulación de lo que dijiste]"

[Guardar así]  [Seguir]
```

- "Guardar así" → cierra sheet, llena `gratitudeText` en parent WritingSheet
- "Seguir" → continúa conversación

## 🎨 UI

[[DifficultModeView]]:
- Header rosa soft con icon heart
- Bubbles alternados: coach (sage) izquierda, user (sage solid) derecha
- Typing dots durante coach response
- Input bar con send button circular
- Suggestion card animado con slide-up

## 🤖 Backend

[[DifficultModeService]]:
- Cloud: `POST /ai/difficult-mode` con history context
- Local fallback: árbol Socrático de 3 turnos

## 📏 Reglas de tono

- ❌ NUNCA "Skip", "Omitir", "Salta este día"
- ❌ NUNCA "deberías"
- ✅ Validar primero, siempre
- ✅ "Está bien no encontrar nada"
- ✅ Frases cortas, espacio para respirar
- ✅ Permitir cerrar en cualquier momento sin forzar gratitud

## ⚠️ Crisis Detection (TODO)

⚠️ **Pendiente**: Si user expresa ideación negativa fuerte:
- Override conversación normal
- Validación profunda
- Recursos: línea de crisis país-específico
- Sugerencia profesional
- No intentar cristalizar gratitud

Ver [[AI Architecture]] sección Crisis Detection.

## 🔗 Implementación

- Service: [[DifficultModeService]]
- View: [[DifficultModeView]]
- Trigger: [[WritingSheetView]] (Pro only)

## 🔗 Relacionados
- [[AI Coach]]
- [[Monetization Model]]
- [[AI Architecture]]
- [[v1.2]]
