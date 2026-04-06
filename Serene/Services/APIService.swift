import Foundation

final class APIService {
    static let shared = APIService()

    // TODO: Replace with actual backend URL
    private let baseURL = URL(string: "https://api.serene.app")!

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    private var authToken: String? {
        get { UserDefaults.standard.string(forKey: "authToken") }
        set { UserDefaults.standard.set(newValue, forKey: "authToken") }
    }

    // MARK: - Auth

    struct AuthResponse: Codable {
        let token: String
        let user: UserProfile
    }

    func register(name: String, email: String, password: String) async throws -> AuthResponse {
        let body = ["name": name, "email": email, "password": password]
        let response: AuthResponse = try await post("/auth/register", body: body)
        authToken = response.token
        return response
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        let body = ["email": email, "password": password]
        let response: AuthResponse = try await post("/auth/login", body: body)
        authToken = response.token
        return response
    }

    // MARK: - Gratitudes

    struct GratitudeRequest: Codable {
        let text: String
        let emoji: String
        let photoURL: String?
        let slotIndex: Int
        let isExtra: Bool
    }

    struct GratitudeResponse: Codable {
        let id: UUID
        let aiResponse: String?
    }

    func createGratitude(_ request: GratitudeRequest) async throws -> GratitudeResponse {
        try await post("/gratitudes", body: request, authenticated: true)
    }

    func fetchGratitudes(date: Date? = nil) async throws -> [Gratitude] {
        var path = "/gratitudes"
        if let date {
            let formatter = ISO8601DateFormatter()
            path += "?date=\(formatter.string(from: date))"
        }
        return try await get(path, authenticated: true)
    }

    // MARK: - Streak

    func fetchStreak() async throws -> Streak {
        try await get("/streak", authenticated: true)
    }

    func rescueStreak() async throws -> Streak {
        try await post("/streak/rescue", body: EmptyBody(), authenticated: true)
    }

    // MARK: - Insights

    func fetchWeeklySummary() async throws -> WeeklySummary {
        try await get("/insights/weekly", authenticated: true)
    }

    // MARK: - Networking

    private struct EmptyBody: Codable {}

    private func get<T: Decodable>(_ path: String, authenticated: Bool = false) async throws -> T {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = "GET"
        if authenticated, let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode(T.self, from: data)
    }

    private func post<T: Decodable, B: Encodable>(_ path: String, body: B, authenticated: Bool = false) async throws -> T {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encoder.encode(body)
        if authenticated, let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode(T.self, from: data)
    }
}
