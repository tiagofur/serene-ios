import Foundation
import SwiftUI

// MARK: - Auth DTOs
struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct RegisterRequest: Encodable {
    let name: String
    let email: String
    let password: String
    let locale: String
}

struct AuthResponse: Decodable {
    let token: String
    let user: UserDTO
}

struct UserDTO: Decodable {
    let id: String
    let name: String
    let email: String
    let locale: String
    let tier: String
    let trialEndsAt: String?
}

// MARK: - Auth Service
final class AuthService: ObservableObject {
    static let shared = AuthService()
    @Published var isAuthenticated = false

    private let tokenKey = "serene_auth_token"

    private init() {
        if let token = storedToken {
            APIService.shared.setAuthToken(token)
            isAuthenticated = true
        }
    }

    var storedToken: String? {
        KeychainHelper.read(key: tokenKey)
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        let request = LoginRequest(email: email, password: password)
        let response: AuthResponse = try await APIService.shared.request(
            endpoint: "/auth/login",
            method: "POST",
            body: request
        )
        saveToken(response.token)
        return response
    }

    func register(name: String, email: String, password: String, locale: String = "es") async throws -> AuthResponse {
        let request = RegisterRequest(name: name, email: email, password: password, locale: locale)
        let response: AuthResponse = try await APIService.shared.request(
            endpoint: "/auth/register",
            method: "POST",
            body: request
        )
        saveToken(response.token)
        return response
    }

    func logout() {
        KeychainHelper.delete(key: tokenKey)
        APIService.shared.setAuthToken(nil)
        DispatchQueue.main.async {
            self.isAuthenticated = false
        }
    }

    private func saveToken(_ token: String) {
        KeychainHelper.save(key: tokenKey, value: token)
        APIService.shared.setAuthToken(token)
        DispatchQueue.main.async {
            self.isAuthenticated = true
        }
    }
}

// MARK: - Simple Keychain Helper
enum KeychainHelper {
    static func save(key: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    static func read(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    static func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
        ]
        SecItemDelete(query as CFDictionary)
    }
}
