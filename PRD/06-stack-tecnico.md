# 8. Stack Tecnico y Arquitectura

## 8.1 Stack

| Capa | Tecnologia | Notas |
|---|---|---|
| iOS app | SwiftUI + Swift nativo | iOS 17+ minimo. SF Symbols para iconos. |
| Android (fase 2) | Jetpack Compose | Misma logica de negocio, UI adaptada a Material You |
| Backend | Go (existente) | Auth ya implementado. Endpoints REST para gratitudes e IA. |
| Base de datos | PostgreSQL | Gratitudes, usuarios, sesiones, patrones |
| IA on-device | Apple Intelligence + Core ML | Sentimiento, temas frecuentes, frases. iOS 17+. |
| IA cloud | DeepSeek V3 o Gemini Flash | Coach personalizado, resumen semanal, modo dificil |
| Pagos iOS | StoreKit 2 | Suscripciones mensuales y anuales. Trial 14d. |
| Notificaciones | APNs (iOS nativo) | Notificaciones locales + remotas desde Go backend |
| Fuentes | DM Serif Display + Plus Jakarta Sans | Google Fonts — incluir en bundle |
| Almacenamiento local | SwiftData o CoreData | Gratitudes offline-first. Sync con backend. |

---

## 8.2 Modelo de datos (simplificado)

### User

| Campo | Tipo |
|---|---|
| id | UUID |
| name | String |
| email | String |
| locale | String |
| tier | Enum (free/pro) |
| trial_ends_at | DateTime? |
| reminder_time | Time? |

Relaciones: 1:N con Gratitudes

### Gratitude

| Campo | Tipo |
|---|---|
| id | UUID |
| user_id | UUID (FK) |
| text | String |
| emoji | String |
| photo_url | String? |
| ai_response | String? |
| sentiment_score | Float? |
| created_at | DateTime |

Relaciones: N:1 con User

### WeeklySummary

| Campo | Tipo |
|---|---|
| id | UUID |
| user_id | UUID (FK) |
| week_start | Date |
| narrative | String |
| top_topics | [String] |
| sentiment_trend | String |
| created_at | DateTime |

Relaciones: N:1 con User

### Streak

| Campo | Tipo |
|---|---|
| user_id | UUID (FK) |
| current_streak | Int |
| longest_streak | Int |
| last_entry_date | Date |
| rescues_used | Int |

Relaciones: 1:1 con User

### Pattern

| Campo | Tipo |
|---|---|
| id | UUID |
| user_id | UUID (FK) |
| type | String |
| content | String |
| detected_at | DateTime |
| acknowledged | Bool |

Relaciones: N:1 con User

---

## 8.3 API endpoints principales (Go backend)

| Metodo | Endpoint | Descripcion | Auth |
|---|---|---|---|
| POST | `/auth/register` | Registro de nuevo usuario | Publico |
| POST | `/auth/login` | Login, devuelve JWT | Publico |
| GET | `/user/me` | Perfil del usuario autenticado | JWT |
| POST | `/gratitudes` | Crear nueva gratitud + trigger IA coach | JWT |
| GET | `/gratitudes` | Listar gratitudes (paginado, filtros fecha) | JWT |
| GET | `/gratitudes/:id` | Detalle de una gratitud | JWT |
| GET | `/streak` | Estado actual de racha | JWT |
| POST | `/streak/rescue` | Usar rescate de racha (1/mes) | JWT |
| GET | `/insights/weekly` | Resumen semanal (Free: 1/mes, Pro: ilimitado) | JWT |
| GET | `/insights/patterns` | Patrones emocionales detectados | JWT + Pro |
| POST | `/ai/coach` | Generar respuesta personalizada del coach | JWT + interno |
| POST | `/subscriptions/trial` | Iniciar trial Pro de 14 dias | JWT |
| GET | `/subscriptions/status` | Estado de suscripcion actual | JWT |
