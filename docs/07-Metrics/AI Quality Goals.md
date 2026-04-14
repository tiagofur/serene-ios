---
tags: [metrics, ai, quality]
updated: 2026-04-14
---

# AI Quality Goals

Métricas y prácticas para mantener calidad del coach AI.

## 🎯 Targets

| Métrica | Objetivo | Cómo medir |
|---|---|---|
| Rating respuestas coach | >4.2/5 | In-app feedback opcional (TODO) |
| % "se sintió personalizada" | >70% | Survey post-trial |
| Latencia coach response | <3s | Telemetry |
| Coste tokens por user Pro/semana | <$0.005 | Backend metering |
| Crisis detection accuracy | 100% recall, low false-positive | Manual review |

## 🧪 Cómo evaluamos calidad

### 1. In-app rating (TODO)
Después de N gratitudes, prompt: "¿La respuesta del coach se sintió personalizada?"
Opciones: 👍 / 👎 + opcional reason

### 2. Manual review semanal
Random sample de 50 responses → human review:
- ¿Tono apropiado?
- ¿Genuinely personal o genérico?
- ¿Length apropiado?
- ¿Crisis flagged correctly?

### 3. A/B test prompts
Variantes de system prompt → measure rating delta.

## 📝 Reglas de respuesta del coach

Auditadas en cada PR que toca prompts:

### Tono
- ✅ Cálido, validador
- ✅ Usa nombre del usuario
- ✅ Máximo 2 frases
- ❌ Nunca clínico
- ❌ Nunca da consejos médicos
- ❌ Nunca pregunta que requiera respuesta

### Estructura
- 1 frase de validación / reconocimiento
- 1 frase de reflexión / refuerzo
- Emoji al final (sage / sparkle / leaf / heart)

### Personalización
- Referenciar contenido específico del user
- Usar topics recurrentes cuando posible (con contexto)
- Adaptar a hora del día (mañana ≠ noche)

## 🚨 Crisis Detection

⚠️ **TODO crítico** ([[Backlog]] P0)

### Keywords a detectar (en español)
- "no quiero vivir", "no vale la pena", "ya no puedo"
- "mejor no estar", "rendirme", "acabar con"
- "lastimarme", "hacer daño"
- + variantes regional

### Acción al detectar
1. Reemplazar respuesta normal con safety response
2. Validar el sentimiento profundamente
3. Listar recursos:
   - 🇲🇽 LOCATEL: 55 5658 1111
   - 🇪🇸 Teléfono Esperanza: 717 003 717
   - 🇦🇷 Centro de Asistencia al Suicida: 135
   - Internacional: 988 (US)
4. Sugerir hablar con profesional
5. NO intentar coach normal hasta que user clarifique

### Implementación
- Cliente: keyword detection (instant safety net)
- Servidor: prompt instruction explícita + override
- Logging: flag interno para review (sin enviar contenido)

## 🔧 Prompt engineering

### System prompt actual (a definir definitivo)
```
Eres un coach de gratitud cálido y personal. Tu rol es validar
y acompañar, no aconsejar.

Reglas:
- Responde en máximo 2 frases.
- Usa el nombre del usuario.
- Tono cálido, no clínico.
- Si detectas señales de crisis (ideación, daño), responde
  con validación + recursos de ayuda. Nunca uses tono normal.
- No des consejos médicos.
- Termina con un emoji apropiado: 🌿 ✨ 🙏 🌱 💚 🍃 🌻

Contexto del usuario:
- Nombre: {userName}
- Gratitudes recientes: {previousGratitudes}
```

### Prompt iteración
- Versionar system prompts con tag (`v1.0-coach`)
- A/B test variants
- Rollback fácil si quality drop

## 🛡️ Fallback quality

Local fallbacks en [[AICoachService]] deben ser:
- ✅ Tan cálidos como cloud
- ✅ Variados (mín 7 plantillas)
- ✅ Personalizados con `userName`
- ✅ Con emoji apropiado

Re-revisar fallbacks cada vez que cambies system prompt cloud.

## 🔗 Relacionados
- [[AI Architecture]]
- [[AICoachService]]
- [[DifficultModeService]]
- [[ADR-002 - Hybrid AI Architecture]]
- [[Crisis Detection]] (TODO doc)
