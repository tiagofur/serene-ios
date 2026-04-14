import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()

    private init() {}

    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound])
            return granted
        } catch {
            return false
        }
    }

    func scheduleDailyReminder(at time: Date, userName: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily_gratitude_reminder"])

        let content = UNMutableNotificationContent()

        let greetings = [
            "\(userName), hoy es un buen día para agradecer. ¿Qué te hizo sonreír? 🌿",
            "Oye \(userName), ¿un momento para ti? Tu ritual de gratitud te espera. ✨",
            "\(userName), 3 pequeños agradecimientos pueden cambiar tu día. ¿Vamos? 🙏",
            "Tu momento de calma te espera, \(userName). ¿Qué fue bueno hoy? 🍃",
        ]
        content.body = greetings.randomElement() ?? greetings[0]
        content.sound = .default

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: "daily_gratitude_reminder",
            content: content,
            trigger: trigger
        )

        center.add(request)
    }

    func cancelAllReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
