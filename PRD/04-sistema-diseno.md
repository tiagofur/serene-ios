# 5. Sistema de Diseno

## 5.1 Filosofia visual

Serene usa una estetica de **"tierra organica"** que evita intencionalmente los azules/purpuras clinicos tipicos de apps de salud mental. Los colores evocan calidez, naturaleza y presencia. La app debe sentirse como una taza de cafe caliente, no como un dashboard de analytics.

---

## 5.2 Paleta de colores

### Modo claro

| Token | Hex | Uso |
|---|---|---|
| Fondo principal | `#FDFAF6` | Background de todas las pantallas |
| Superficie | `#F4EFE8` | Cards, slots de gratitud, areas de contenido |
| Card elevada | `#FFFFFF` | Modales, overlays, coach reply |
| Acento tierra (primary) | `#7C6E5A` | Textos secundarios, borders principales |
| Sage (CTA / accion) | `#5A7A6B` | Botones principales, tab activo, checks, racha |
| Sage soft | `#E0EDE7` | Fondos de elementos sage (pills, badges) |
| Arena (calidez) | `#C4956A` | Extras desbloqueados, elementos de logro |
| Arena soft | `#F5EAD8` | Fondos arena, tag de extras |
| Rosa (empatia) | `#C0706E` | Elementos emocionales, acentos suaves |
| Rosa soft | `#F5E4E3` | Fondos rosa |
| Texto primario | `#2D2420` | Todo el texto principal |
| Texto secundario | `#7C6E5A` | Labels, subtextos, metadatos |
| Texto terciario | `#9E8A78` | Placeholders, hints, fechas |
| Border default | `#D4C5B0` | Borders de cards y slots |

### Modo oscuro

| Token | Hex | Uso |
|---|---|---|
| Fondo principal | `#17130F` | Background de todas las pantallas |
| Superficie | `#221C16` | Cards, slots, areas de contenido |
| Card elevada | `#2C2419` | Modales, overlays, coach reply |
| Sage (CTA) | `#8BBCA8` | Botones, tab activo, checks — mas claro que light |
| Arena | `#E0A87A` | Extras, logros |
| Rosa | `#D98F8D` | Elementos emocionales |
| Texto primario | `#F2EBE3` | Todo el texto principal |
| Texto secundario | `#B09A8C` | Labels, subtextos |
| Texto terciario | `#6E5E54` | Placeholders, hints |
| Border default | `#3A2E22` | Borders de cards |

### Referencia visual de paleta

```
MODO CLARO                              MODO OSCURO

Fondos                                  Fondos
+----------+----------+----------+      +----------+----------+----------+
| #FDFAF6  | #F4EFE8  | #FFFFFF  |      | #17130F  | #221C16  | #2C2419  |
| Fondo    | Superf.  | Card     |      | Fondo    | Superf.  | Card     |
+----------+----------+----------+      +----------+----------+----------+

Acentos                                 Acentos
+----------+----------+----------+      +----------+----------+----------+
| #5A7A6B  | #C4956A  | #C0706E  |      | #8BBCA8  | #E0A87A  | #D98F8D  |
| Sage     | Arena    | Rosa     |      | Sage     | Arena    | Rosa     |
+----------+----------+----------+      +----------+----------+----------+

Soft variants                           Textos
+----------+----------+----------+      +----------+----------+----------+
| #E0EDE7  | #F5EAD8  | #F5E4E3  |      | #F2EBE3  | #B09A8C  | #6E5E54  |
| Sage s.  | Arena s. | Rosa s.  |      | Primario | Secund.  | Terciario|
+----------+----------+----------+      +----------+----------+----------+

Textos
+----------+----------+----------+
| #2D2420  | #7C6E5A  | #9E8A78  |
| Primario | Secund.  | Terciario|
+----------+----------+----------+
```

---

## 5.3 Tipografia

| Rol | Fuente | Tamano | Peso | Uso |
|---|---|---|---|---|
| Display | DM Serif Display | 28-32pt | Regular | Saludo del usuario, titulos grandes, unlock |
| Heading | Plus Jakarta Sans | 18-22pt | SemiBold (600) | Titulos de seccion dentro de pantallas |
| Body | Plus Jakarta Sans | 14-15pt | Regular (400) | Texto de gratitudes, respuestas del coach |
| Label | Plus Jakarta Sans | 11-12pt | Medium (500) | Metadata, counters, tags, section heads |
| Micro | Plus Jakarta Sans | 10pt | Medium (500) | Status bar, tab labels, char count |

### Regla tipografica clave

**DM Serif Display** solo para los momentos emocionales importantes: el saludo del usuario, el titulo de la celebracion de unlock, el resumen semanal. El serif da calidez y peso emocional.

**Plus Jakarta Sans** para todo lo funcional: botones, labels, metadatos, texto de gratitudes.

---

## 5.4 Espaciado y radios

| Token | Valor | Uso |
|---|---|---|
| xs | 4px | Gap minimo entre elementos inline |
| sm | 8px | Gap interno de components pequenos (pills, dots) |
| md | 16px | Padding interno de cards y slots |
| lg | 24px | Separacion entre secciones |
| xl | 40px | Espaciado de pantalla, margenes principales |

| Token | Valor | Uso |
|---|---|---|
| radius-sm | 8px | Botones pequenos, pills, badges |
| radius-md | 12px | Cards, coach reply, streak card |
| radius-lg | 16px | Slots de gratitud, overlays, bottom sheet |
| radius-xl | 24px | Extra slots desbloqueados, modal principal |
| radius-device | 36-44px | Device shell del mockup |

| Token | Valor | Uso |
|---|---|---|
| border-default | 0.5px | Todos los borders en estado normal |
| border-emphasis | 1.5px | Slot activo, extra desbloqueado, featured |
