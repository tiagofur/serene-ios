---
tags: [architecture, api, backend]
updated: 2026-04-14
---

# API Endpoints

Endpoints del backend Go que la app consume. Base URL configurada en [[APIService]] (`APIConfig.baseURL`).

## 🔐 Auth

### POST `/auth/register`
Registro de nuevo usuario.

**Auth**: Público
**Body**:
```json
{
  "name": "string",
  "email": "string",
  "password": "string",
  "locale": "es"
}
```
**Response**: `AuthResponse { token, user }`

### POST `/auth/login`
Login con credentials.

**Auth**: Público
**Body**: `{ "email", "password" }`
**Response**: `AuthResponse { token, user }`

---

## 👤 User

### GET `/user/me`
Perfil del usuario autenticado.

**Auth**: JWT
**Response**: `UserDTO`

---

## 🌱 Gratitudes

### POST `/gratitudes`
Crear nueva gratitud + trigger AI coach response.

**Auth**: JWT
**Body**:
```json
{
  "text": "string",
  "emoji": "string",
  "slotIndex": 0,
  "isExtra": false
}
```
**Response**: `GratitudeResponse { id, text, emoji, aiResponse, sentimentScore, createdAt }`

**Notas**: El backend dispara internamente la llamada al modelo cloud y devuelve `aiResponse` ya generada.

### GET `/gratitudes`
Listar gratitudes (paginado, filtros fecha).

**Auth**: JWT
**Query params**: `?from=ISO&to=ISO&limit=50&offset=0`
**Response**: `[GratitudeResponse]`

### GET `/gratitudes/:id`
Detalle de una gratitud.

**Auth**: JWT
**Response**: `GratitudeResponse`

---

## 🔥 Streak

### GET `/streak`
Estado actual de racha.

**Auth**: JWT
**Response**: `{ currentStreak, longestStreak, lastEntryDate, rescuesUsedThisMonth }`

### POST `/streak/rescue`
Usar rescate de racha (1/mes).

**Auth**: JWT
**Response**: `{ success: bool, newStreak: int }`

---

## 📊 Insights

### GET `/insights/weekly`
Resumen semanal narrativo.

**Auth**: JWT
**Query**: `?week=ISO`
**Response**: `{ narrative, topTopics: [], sentimentTrend, dominantEmoji }`
**Gating**: Free 1/mes, Pro ilimitado (validation server-side)

### GET `/insights/patterns`
Patrones emocionales detectados.

**Auth**: JWT + Pro tier
**Response**: `{ connections: [], languageEvolution: {}, sentimentSeries: [] }`

---

## 🤖 AI

### POST `/ai/coach`
Generar respuesta personalizada del coach.

**Auth**: JWT (interno, llamado desde `/gratitudes`)
**Body**:
```json
{
  "gratitudeText": "string",
  "emoji": "string",
  "userName": "string",
  "previousGratitudes": ["..."]
}
```
**Response**: `{ "response": "string" }`

### POST `/ai/difficult-mode`
Coach conversacional para [[Difficult Mode]].

**Auth**: JWT + Pro tier
**Body**:
```json
{
  "userName": "string",
  "conversationHistory": [{ "role": "coach|user", "content": "..." }],
  "currentMessage": "string"
}
```
**Response**: `{ "response": "string", "suggestedGratitude": "string?" }`

---

## 💳 Subscriptions

### POST `/subscriptions/trial`
Iniciar trial Pro de 14 días.

**Auth**: JWT
**Response**: `{ trialEndsAt: "ISO" }`

### GET `/subscriptions/status`
Estado de suscripción actual.

**Auth**: JWT
**Response**: `{ tier: "free|pro", status: "active|trial|expired", expiresAt: "ISO?" }`

### POST `/subscriptions/restore`
Restaurar compras (StoreKit receipt validation).

**Auth**: JWT
**Body**: `{ "receipt": "base64..." }`
**Response**: `{ valid: bool, tier, expiresAt }`

---

## 🔁 Sync (futuro)

Endpoints planeados para offline sync:

### POST `/sync/gratitudes/batch`
Subir gratitudes pendientes en batch.

### GET `/sync/changes`
Pull de cambios desde timestamp.

⚠️ **TODO**: La estrategia de sync incremental no está implementada. Hoy cada `POST /gratitudes` es individual y silenciosamente fallback offline.

---

## 🛡️ Errors

| Status | Significado |
|---|---|
| 200-299 | Success |
| 401 | Token expirado/inválido → forzar logout |
| 403 | No tier suficiente (free intentando endpoint Pro) |
| 422 | Validación falló |
| 429 | Rate limited (raro) |
| 500 | Server error → fallback offline |

Cliente: `APIError` enum en [[APIService]].

## 🔗 Relacionados
- [[APIService]]
- [[AuthService]]
- [[Tech Stack]]
- [[Authentication]]
