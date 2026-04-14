---
tags: [service, code, network]
file: Serene/Services/APIService.swift
---

# APIService

HTTP client central. Singleton, thread-safe, async/await.

## Responsabilidades
- Construir URLRequests con base URL + headers
- Inyectar JWT token automáticamente
- Decodificar JSON con `iso8601` dates
- Mapear errores HTTP a `APIError` enum

## API Pública

```swift
final class APIService {
    static let shared: APIService

    func setAuthToken(_ token: String?)

    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil
    ) async throws -> T
}
```

## Configuración

```swift
enum APIConfig {
    static var baseURL: String {
        #if DEBUG
        return "http://localhost:8080"
        #else
        return "https://api.serene.app"
        #endif
    }
}
```

URLSession config:
- `timeoutIntervalForRequest: 15`
- `timeoutIntervalForResource: 30`

## Errores

```swift
enum APIError {
    case invalidURL
    case invalidResponse
    case unauthorized          // 401 → forzar logout
    case serverError(Int)
    case decodingError(Error)
    case networkError(Error)   // sin internet, timeout
}
```

Cada caso tiene `errorDescription` localizado al español.

## Patrón de uso

```swift
do {
    let response: SomeResponse = try await APIService.shared.request(
        endpoint: "/some/path",
        method: "POST",
        body: SomeRequest(...)
    )
    // Use response
} catch APIError.unauthorized {
    AuthService.shared.logout()
} catch {
    // Fall back to local
}
```

## Limitaciones

- ❌ No retry logic (TODO en [[v2.0]])
- ❌ No request batching
- ❌ No reachability monitoring (`NWPathMonitor`)
- ❌ No request cancellation explícita

## Tests pendientes
- [ ] URLSession mock con respuestas controladas
- [ ] Verificar 401 cleanup
- [ ] Verificar timeout handling

## 🔗 Relacionados
- [[Tech Stack]]
- [[API Endpoints]]
- [[AuthService]]
- [[Offline-First Strategy]]
