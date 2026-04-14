import SwiftUI
import Combine

final class AppState: ObservableObject {
    @Published var userName: String = UserDefaults.standard.string(forKey: "userName") ?? ""
    @Published var userTier: UserTier = .free
    @Published var reminderTime: Date = UserDefaults.standard.object(forKey: "reminderTime") as? Date ?? Calendar.current.date(from: DateComponents(hour: 21, minute: 0)) ?? Date()
    @Published var isAuthenticated: Bool = false

    @Published var appearance: AppAppearance {
        didSet {
            UserDefaults.standard.set(appearance.rawValue, forKey: "appAppearance")
        }
    }

    init() {
        let stored = UserDefaults.standard.string(forKey: "appAppearance") ?? AppAppearance.system.rawValue
        self.appearance = AppAppearance(rawValue: stored) ?? .system
    }

    enum UserTier: String, Codable {
        case free
        case pro
    }

    func updateUserName(_ name: String) {
        userName = name
        UserDefaults.standard.set(name, forKey: "userName")
    }

    func updateReminderTime(_ time: Date) {
        reminderTime = time
        UserDefaults.standard.set(time, forKey: "reminderTime")
    }
}
