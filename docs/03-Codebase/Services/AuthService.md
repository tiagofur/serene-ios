---
tags: [service, code, auth, security]
file: Serene/Services/AuthService.swift
---

# AuthService

Manejo de autenticación. JWT token persistido en Keychain.

## Responsabilidades
- Login / register endpoints
- Persistir JWT en Keychain (no UserDefaults — security)
- Inyectar token en `APIService` automáticamente
- Logout y cleanup

## API Pública

```swift
final class AuthService: ObservableObject {
    static let shared: AuthService

    @Published var isAuthenticated: Bool

    var storedToken: String? { get }

    func login(email: String, password: String) async throws -> AuthResponse
    func register(name: String, email: String, password: String, locale: String) async throws -> AuthResponse
    func logout()
}
```

## Keychain Helper

```swift
enum KeychainHelper {
    static func save(key: String, value: String)
    static func read(key: String) -> String?
    static func delete(key: String)
}
```

Usa `kSecClassGenericPassword` con `kSecAttrAccount`. No accessibility level explícito (TODO: `kSecAttrAccessibleAfterFirstUnlock`).

## DTOs

```swift
struct AuthResponse: Decodable {
    let token: String
    let user: UserDTO
}

struct UserDTO: Decodable {
    let id, name, email, locale, tier: String
    let trialEndsAt: String?
}
```

## Flujo de inicialización

```
App start
    ↓
AuthService.init()
    ↓
storedToken via Keychain
    ├── exists → APIService.setAuthToken(token), isAuthenticated = true
    └── nil → user must login (TODO: actualmente onboarding no requiere login)
```

## ⚠️ Estado actual

- ✅ Keychain funcional
- ✅ Token injection en APIService
- ❌ **Login UI no implementada** — el onboarding no fuerza login
- ❌ Sin refresh token
- ❌ Sin biometric unlock

Esto es intencional para v1.0: **uso completamente local sin cuenta**. Cuando el usuario quiera sync entre devices ([[v2.0]]), se añade el flow de login post-onboarding.

## Tests pendientes
- [ ] Mock URLSession para login flow
- [ ] Keychain leak entre runs
- [ ] Logout cleanup completo

## 🔗 Relacionados
- [[APIService]]
- [[Authentication]]
- [[Security and Privacy]]
- [[API Endpoints]]
