---
tags: [architecture, security, privacy]
updated: 2026-04-14
---

# Security and Privacy

Postura de seguridad y privacidad de Serene.

## 🎯 Principios

1. **Privacy by default**: opt-in para todo lo que sale del device
2. **Mínimos datos**: enviar solo lo necesario
3. **Local primero**: análisis sensible on-device
4. **Transparencia**: privacy policy clara, no dark patterns

## 🔐 Datos en device

| Dato | Storage | Protection |
|---|---|---|
| Gratitudes | SwiftData (SQLite) | iOS Data Protection default |
| Streak data | SwiftData | iOS Data Protection default |
| User name | UserDefaults | iOS sandboxing |
| Auth token | **Keychain** | Encrypted, biometric-gated possible |
| Reminder time | UserDefaults | iOS sandboxing |

⚠️ **TODO**: Migrar SwiftData store a `NSFileProtectionComplete` (encriptado mientras app no corra).

## 🌐 Datos en transit

- ✅ **HTTPS** vía URLSession (default)
- ⚠️ **TODO**: SSL Pinning para prevenir MITM en redes hostiles
- ⚠️ **TODO**: Certificate transparency check

## 🤖 Datos enviados a IA cloud

Para coach response, se envía:
```json
{
  "gratitudeText": "Hoy agradezco...",
  "emoji": "😊",
  "userName": "María",
  "previousGratitudes": ["text1", "text2"]
}
```

**NO se envía**:
- Email
- IP en payload (sí en HTTPS metadata)
- ID device
- Location
- Photos

**Backend logging**:
- Logs de prompts: max 7 días
- Sin agregación cross-user
- Sin venta de datos

## 🛡️ Cloud LLM provider

DeepSeek / Gemini Flash:
- ✅ Tienen políticas de no-training en customer data (verificar terms)
- ✅ EU data residency cuando aplique
- ⚠️ No usar OpenAI por concerns de policies cambiantes

## 🚫 Lo que NUNCA hacemos

- ❌ Vender datos
- ❌ Ads
- ❌ Tracking cross-app
- ❌ Compartir datos con terceros sin consent
- ❌ Almacenar credit cards (StoreKit lo maneja Apple)

## 📜 Privacy Policy (TODO)

⚠️ **Pendiente**: redactar privacy policy. Debe incluir:
- Qué recolectamos
- Cómo usamos
- Con quién compartimos (proveedores AI)
- Retention periods
- Derechos del usuario (GDPR, CCPA, LGPD)
- Contact email para data requests

## 🇪🇺 GDPR compliance

- Right to access: feature de export PDF cumple parcialmente
- Right to delete: TODO "Borrar mi cuenta" en Profile
- Right to portability: PDF export ✅
- Consent: explícito en onboarding (notifications)

## 🇧🇷 LGPD compliance (preparación v2.0)

Similar a GDPR. Necesario para Brasil launch.

## 🔒 App Store privacy labels

Decisión propuesta:
- **Identifiers**: User ID (lo necesitamos para sync)
- **Usage Data**: Product Interaction (analytics, opcional)
- **NOT collected**: Location, Health, Browsing History, Search History

## 🚨 Crisis Detection y privacy

⚠️ Cuando se detecta crisis:
- NO se envía contenido a logs adicionales
- NO se hace flag user-level
- Solo cliente registra evento abstracto para review interno (no contenido)

## 🔗 Relacionados
- [[Authentication]]
- [[AI Architecture]]
- [[Risk Register]]
- [[Backlog]]
