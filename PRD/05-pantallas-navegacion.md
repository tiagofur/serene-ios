# 6. Navegacion y Arquitectura de Pantallas

## 6.1 Estructura global

La navegacion principal es un tab bar de 4 tabs en la parte inferior. No hay sidebar, no hay hamburger menu, no hay navegacion compleja. El usuario llega a su pantalla principal en 0 taps desde el lanzamiento.

| Tab | Icono | Descripcion | Acceso |
|---|---|---|---|
| Hoy | Hoja (SF Symbol: `leaf`) | Pantalla principal. Gratitudes del dia, racha, coach. | Tab 1 — default al abrir |
| Historial | Libro (`book`) | Entradas pasadas con busqueda y filtros. | Tab 2 |
| Insights | Estrella (`sparkles`) | Patrones, resumen semanal, graficas emocionales. | Tab 3 |
| Perfil | Persona (`person.circle`) | Racha, estadisticas, ajustes, suscripcion. | Tab 4 |

### Principio de navegacion

El tab bar **NO tiene badges numerados** en ninguna tab. Serene no genera ansiedad de tareas pendientes. El unico indicador de actividad es el punto de la racha en la pantalla Hoy. La accion principal (escribir gratitud) ocurre en la Tab Hoy sin navegacion profunda.

---

## 6.2 Flujo de onboarding

| Paso | Pantalla | Objetivo | Duracion estimada |
|---|---|---|---|
| 1/6 | Bienvenida + estado emocional | Establecer tono calido. Capturar humor inicial. | 20s |
| 2/6 | La ciencia de la gratitud | Dar contexto y credibilidad. Crear expectativa. | 30s |
| 3/6 | Primera gratitud (ahora) | El usuario escribe su primera gratitud EN ESTE MOMENTO. | 60s |
| 4/6 | Respuesta del coach | **LA PANTALLA MAS IMPORTANTE.** El usuario siente la magia. | 30s |
| 5/6 | Hora del ritual diario | Configurar recordatorio. Compromiso de habito. | 15s |
| 6/6 | Oferta de trial Pro | Conversion sin presion. CTA secundario visible y sin culpa. | 20s |

> **Regla critica del onboarding:** La pantalla 4 (Respuesta del coach) debe ejecutarse ANTES de cualquier menu de suscripcion. El usuario necesita experimentar el valor diferencial de Serene antes de ver un precio. Esta secuencia no debe modificarse. Es el argumento de venta mas poderoso de la app.

---

## 6.3 Flujo diario (recurrente)

| Paso | Accion | Pantalla / Componente | Notas |
|---|---|---|---|
| 1 | Notificacion suave | Sistema — APNs | Texto personalizado. No "Recuerda escribir tus gratitudes". |
| 2 | Abrir app -> Tab Hoy | Tab Hoy | Saludo con nombre + hora del dia. Racha actualizada. |
| 3 | Tocar slot de gratitud | Bottom sheet (escritura) | Sube con animacion spring. Handle de arrastre visible. |
| 4 | Seleccionar emoji + escribir | Sheet de escritura | Campo sin limite. Foto opcional. Sin friccion. |
| 5 | Guardar | Sheet de escritura | Anima typing dots -> respuesta del coach aparece inline. |
| 6 | Repetir para gratitud 2 y 3 | Tab Hoy | Los slots van marcando check conforme se completan. |
| 7 | Completar las 3 | Overlay de celebracion | Overlay sube suave. Particulas flotantes. Racha +1 pop. |
| 8 | Ver extras desbloqueados | Overlay de celebracion | Extra 1 y Extra 2 aparecen en secuencia con slide-up. |
| 9 | Escribir extra (opcional) | Bottom sheet (escritura) | Mismo flow. Prompt diferente. Sin presion. |
| 10 | Cerrar | Tab Hoy | "Por hoy es suficiente" — lenguaje que valida el logro. |

---

# 7. Especificaciones de Pantallas

## 7.1 Tab Hoy — pantalla principal

### Componentes

- **Status bar** nativo iOS — texto primario, sin fondo especial
- **Saludo:** DM Serif Display 28pt + emoji de temporada. Subtexto: "Buenos dias" en label 12pt
- **Streak card:** border radius 18px, fondo superficie, icon 36x36 radius 12, numero 20pt bold sage, label 11pt terciario
- **7 dots de racha:** 8x8px, border-radius 50%, colores: done=sage, today=arena, empty=transparent+border
- **Section head:** 11pt, 600 weight, uppercase, letter-spacing 0.06em, color terciario
- **Slots de gratitud:** radius 16px, padding 13-16px, border 0.5px default
  - Estado done: fondo superficie, border default, check verde sage 18x18 radius-50
  - Estado activo: border 1.5px sage, sin fondo especial
  - Estado vacio: border 1.5px dashed color border
- **Coach reply inline:** radius 10px, padding 8-12px, fondo earth-light, avatar 20x20 radius-50 sage
- **Extra slots bloqueados:** dashed border, fondo superficie, lock icon 28x28 radius 8
- **CTA principal:** radius 16px, padding 15px, fondo sage, texto blanco 14pt 600
- **Tab bar:** border-top 0.5px, padding 10px+safe-area, icon activo con fondo sage radius 7

### Estados

| Estado | Descripcion |
|---|---|
| Sin gratitudes | Todos los slots en estado vacio dashed. CTA: "Empezar mi primer momento" |
| Parcialmente completo | Slots hechos muestran check + texto + coach reply colapsado |
| Completo (3/3) | Todos los slots con check. Overlay de celebracion aparece automaticamente |
| Completo con extras | Overlay cerrado, extras con fondo arena y border arena 1.5px |

---

## 7.2 Sheet de escritura

### Comportamiento

- **Presentacion:** bottom sheet modal con detent medio y completo. Spring animation (damping 0.8)
- **Handle de arrastre:** 36x4px, radius 2px, color border, centrado, margin-top 8px
- **Header:** label izquierda "Gratitud X de Y", boton cerrar 28x28 radius-50 derecha
- **Prompt dinamico:** cambia segun el numero de gratitud. Ver tabla de prompts en seccion 2
- **Selector emoji:** 5 botones 40x40px radius 12. Seleccionado: border 1.5px sage
- **Campo de texto:** radius 16px, padding 14-16px, min-height 100px. Border 1.5px default, focus=sage
- Sin contador de caracteres visible. Sin limite. El placeholder desaparece al primer caracter
- **Boton foto:** dashed border, "opcional" explicito en el label. Nunca bloquea el flujo
- **Al guardar:** boton desaparece, typing dots aparecen (3 puntos animados 350ms por ciclo)
- **Respuesta del coach:** aparece inline caracter a caracter (~28ms por caracter). No navega a otra pantalla
- **Post-respuesta:** boton "Guardar y continuar" reaparece, el sheet se puede cerrar

---

## 7.3 Overlay de celebracion (unlock extras)

### Animacion secuenciada

| Tiempo | Animacion |
|---|---|
| t=0ms | Particulas flotantes (18 particulas, colores de la paleta, float-up 900-1700ms) |
| t=80ms | Overlay sube con spring animation (translateY de +60px a 0, opacity 0->1, 400ms) |
| t=150ms | Ring central hace pop-in (scale 0.4->1 con overshoot 1.12, 500ms) |
| t=400ms | Titulo slide-up (translateY +8px -> 0, opacity, 400ms ease) |
| t=550ms | Subtitulo slide-up (mismo efecto, 400ms ease) |
| t=300ms | Numero de racha hace streakPop (scale 1->1.25->1, 400ms) |
| t=900ms | Extra slot 1 slide-up (opacity + translateY, 350ms) |
| t=1100ms | Extra slot 2 slide-up (mismo, 350ms) |

### Componentes del overlay

- **Ring central:** 64x64px, radius-50, fondo earth-light, border 2px sage, emoji dentro 30pt
- **Titulo:** DM Serif Display 22pt dark
- **Subtitulo:** Plus Jakarta Sans 13pt secondary
- **Extra slots:** radius 16px, border 1.5px arena, fondo superficie, tag "Extra N" pill arena
- **Boton salida:** texto simple sin borde. "Por hoy es suficiente" — **NUNCA** "Omitir" o "Skip"
