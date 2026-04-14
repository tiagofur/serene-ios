---
tags: [service, code, ai, difficult-mode]
file: Serene/Services/DifficultModeService.swift
version_introduced: 1.2
---

# DifficultModeService

Coach conversacional para días bloqueados. Cloud + Socratic local fallback.

## Responsabilidades
- Generar mensaje opening cálido
- Respuestas conversacionales con history context
- Sugerir crystallized gratitude cuando detecta candidato

## API Pública

```swift
final class DifficultModeService {
    static let shared: DifficultModeService

    func openingMessage(userName: String) -> String

    func getResponse(
        userName: String,
        history: [DifficultModeMessage],
        userMessage: String
    ) async -> DifficultModeResponse
}
```

## Modelos

### `DifficultModeMessage`
```swift
struct DifficultModeMessage: Identifiable, Equatable {
    let id: UUID
    let role: Role           // .coach | .user
    let content: String
    let timestamp: Date
}
```

### `DifficultModeResponse`
```swift
struct DifficultModeResponse: Decodable {
    let response: String
    let suggestedGratitude: String?  // Aparece cuando el coach cristaliza
}
```

## Conversation Tree (Local Fallback)

3 turnos Socráticos cuando offline:

### Turn 0 → 1: Validar y redirigir al cuerpo
> _"Escucho eso, María. No hace falta que nada tenga sentido aún. ¿Qué notaste en tu cuerpo hoy? Un respiro, un cambio de luz, el peso de un café caliente…"_

### Turn 1 → 2: Buscar micro-momentos
- Si user dice "nada" o respuesta corta:
  > _"Está bien. Intentemos algo más pequeño: ¿estás en un espacio seco, abrigado, con algo de luz? A veces la gratitud empieza ahí — en lo que damos por hecho."_
- Si user da algo sustantivo:
  > _"Eso que describes es real. ¿Quién o qué te permitió que eso pasara — aunque sea indirectamente?"_

### Turn 2+: Cristalizar
> _"María, lo que acabas de decir ya es gratitud — solo que no la llamamos así. ¿Quieres que lo guardemos juntos?"_

Devuelve `suggestedGratitude` con el mejor mensaje del usuario reformulado a "Hoy agradezco ...".

## Opening messages (3 variantes)

Random selection con `userName`:
- _"Hola María, algunos días nos encuentran vacíos. Está bien. No tienes que forzar nada..."_
- _"Oye María. No todos los días salen las palabras. Empecemos despacio..."_
- _"María, hay días en que agradecer cuesta — y eso también es información valiosa..."_

## Cloud endpoint

`POST /ai/difficult-mode`:
```json
{
  "userName": "string",
  "conversationHistory": [{ "role": "coach|user", "content": "..." }],
  "currentMessage": "string"
}
```

Devuelve: `{ response, suggestedGratitude? }`

## Reglas de tono

- **Nunca** decir "Skip", "Omitir", "Forzar"
- Validar antes de redirigir
- Usar `userName` con frecuencia (no en cada mensaje)
- Frases cortas, espacio para respirar
- Emoji al final cuando sea apropiado, no en cada mensaje

## ⚠️ Crisis Detection

⚠️ **TODO crítico**: Antes de fallback local, detectar señales de crisis. Si match:
- Override con respuesta de validación + recursos
- No intentar cristalizar gratitud
- Sugerir hablar con profesional

Ver [[AI Architecture]] sección Crisis Detection.

## 🔗 Relacionados
- [[Difficult Mode]]
- [[DifficultModeView]]
- [[AI Architecture]]
- [[v1.2]]
