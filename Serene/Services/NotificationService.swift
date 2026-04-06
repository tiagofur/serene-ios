import UserNotifications

final class NotificationService {
    static let shared = NotificationService()

    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound])
        } catch {
            return false
        }
    }

    /// Schedule daily reminder at the user's preferred time
    func scheduleDailyReminder(hour: Int, minute: Int, userName: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily-reminder"])

        let content = UNMutableNotificationContent()
        content.title = "Serene"
        content.body = greetingMessage(for: userName)
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily-reminder", content: content, trigger: trigger)

        center.add(request)
    }

    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // MARK: - Message generation

    private func greetingMessage(for name: String) -> String {
        let messages = [
            "\(name), tu momento de gratitud te espera.",
            "Un minuto para ti, \(name). Que agradeces hoy?",
            "\(name), hoy tiene algo bueno. Descubrelo.",
            "Tu racha sigue viva, \(name). Vamos a mantenerla.",
        ]
        return messages.randomElement()!
    }
}
