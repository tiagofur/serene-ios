# 3. Funcionalidades del Producto

## 3.1 Registro de gratitudes

| Feature | Descripcion | Tier |
|---|---|---|
| Texto libre | Campo sin limite de caracteres. Sin contador visible. Escritura sin friccion. | Free |
| Selector de emoji | 5 estados emocionales seleccionables. Afecta analisis on-device. | Free |
| Foto adjunta | Camara o galeria. Siempre marcado como opcional. Nunca bloquea el flujo. | Free |
| Respuesta coach | IA responde inline bajo cada gratitud al guardar. Animacion de typing. | Free |
| Voz (roadmap v2) | Dictado por voz. IA transcribe y analiza tono emocional. | Pro |

## 3.2 Coach de IA personalizado

La IA no es un chatbot generico. Lee las gratitudes del usuario, recuerda sus temas recurrentes y responde en tono de coach que lo conoce. Nunca da consejos no solicitados. Valida primero, sugiere despues. Usa el nombre del usuario con frecuencia.

| Funcion IA | Motor | Frecuencia | Tier |
|---|---|---|---|
| Respuesta personalizada post-gratitud | API cloud (DeepSeek V3 / Gemini Flash) | Cada registro | Free + Pro |
| Analisis de sentimiento | On-device (Apple Intelligence / Core ML) | Cada registro | Free |
| Frase de animo diaria | On-device — generada por usuario, no global | Diaria | Free |
| Resumen narrativo semanal | API cloud | Free: 1/mes · Pro: semanal | Free + Pro |
| Deteccion de patrones emocionales | API cloud + on-device | Semanal | Pro |
| Modo dificil (guia cuando no encuentras nada) | API cloud conversacional | Bajo demanda | Pro |
| Conexiones inesperadas entre entradas | API cloud | Mensual | Pro |
| Evolucion del lenguaje emocional 30d | API cloud + local analysis | Mensual | Pro |

### Arquitectura de IA — costes estimados

- **On-device** (Apple Intelligence · Core ML · iOS 17+): analisis sentimiento, temas, frases basicas. Coste: **$0**
- **API cloud** (DeepSeek V3 o Gemini Flash): respuesta coach, resumen semanal, modo dificil
- Coste por usuario Pro/semana: ~$0.001–0.003. Con 1,000 Pro users -> **<$15/mes en tokens**
- Usuarios Free NUNCA tocan la API de forma activa. Solo reciben respuestas cloud al guardar gratitudes

## 3.3 Sistema de racha y gamificacion

- **Racha visual:** 7 puntos representan la semana. Sage = completado, arena = hoy, vacio = pendiente
- Numero de racha prominente en la pantalla Hoy. Animacion pop al hacer +1
- La app aprende la hora habitual del usuario y envia nudge suave 15 min antes
- **Hitos:** 7, 30, 100 dias con celebracion en pantalla (no exagerada — no confetti explosion)
- **Rescate de racha:** 1 vez al mes el usuario puede recuperar una racha perdida. Reduce frustracion
- La app **NUNCA** muestra badges de notificacion con numeros en el tab bar. No genera ansiedad

## 3.4 Resumen semanal del coach

- Cada lunes: narrativa personal generada por IA en tono de coach
- Ejemplo: *"Esta semana, Tiago, tu mente estuvo en dos lugares: tu familia y tu trabajo creativo."*
- Palabras clave de la semana resaltadas. Tono emocional dominante con emoji
- **Free:** 1 resumen mensual como muestra. **Pro:** semanal + historico completo
- Compartir como imagen (opcional, nunca forzado)

## 3.5 Insights y patrones (Pro)

- Calendario tipo GitHub contributions: actividad de 30 dias de un vistazo
- Top 3 temas recurrentes de la semana (palabras mas frecuentes en las gratitudes)
- Grafica suave de sentimiento promedio en el tiempo (no fria, no estilo analytics)
- Conexiones inesperadas detectadas por IA: *"Notamos que cuando agradeces naturaleza, tu semana mejora"*
- Evolucion del lenguaje: comparacion de palabras usadas hace 30 dias vs ahora
- Exportar historial en PDF (Pro)
