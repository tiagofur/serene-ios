---
tags: [architecture, auth, security]
updated: 2026-04-14
---

# Authentication

Estrategia de autenticación. Hoy: opcional. Futuro: required para sync multi-device.

## 🎯 Estrategia actual

**Auth opcional**. La app funciona completamente sin login.

- Onboarding NO pide credentials
- SwiftData local almacena todo
- Backend es enriquecimiento (coach response cloud)

## 🔐 Cuando user opta a login

Flow:
1. Usuario va a Profile → "Iniciar sesión" (TODO UI)
2. Email + password
3. [[AuthService]].login → JWT
4. Token guardado en Keychain
5. `APIService.setAuthToken(token)`
6. Background sync de SwiftData ↔ backend (TODO)

## 💾 Storage del token

Keychain con `kSecClassGenericPassword`:

```swift
KeychainHelper.save(key: "serene_auth_token", value: token)
```

⚠️ TODO: Agregar `kSecAttrAccessibleAfterFirstUnlock` explícito.

## 🔁 Token refresh

⚠️ Hoy NO hay refresh token. Cuando expire JWT (401):

```swift
catch APIError.unauthorized {
    AuthService.shared.logout()
    // User must re-login
}
```

Para [[v2.0]]: implementar refresh token rotation.

## 🚪 Logout

```swift
KeychainHelper.delete(key: "serene_auth_token")
APIService.shared.setAuthToken(nil)
isAuthenticated = false
```

⚠️ Hoy NO borra SwiftData local. Decisión: ¿borrar al logout o mantener?
- Pro: el user puede usar local-only
- Con: si user comparte device, datos quedan visibles

Recomendación: mantener local pero ofrecer "Borrar todos mis datos" en Profile.

## 🔒 Biometric (futuro)

[[v2.1]] o on-demand:
- Face ID / Touch ID para abrir app
- Settings opt-in
- Usar `LocalAuthentication` framework

## 🛡️ Seguridad

- ✅ HTTPS en producción
- ✅ JWT en Authorization header (no en URL)
- ✅ Keychain para token
- ⚠️ TODO: SSL pinning para evitar MITM
- ⚠️ TODO: Refresh token rotation
- ⚠️ TODO: Biometric unlock

## 🔗 Relacionados
- [[AuthService]]
- [[APIService]]
- [[Security and Privacy]]
- [[ADR-004 - Offline-First]]
