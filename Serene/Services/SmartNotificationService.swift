import Foundation
import UserNotifications
import SwiftData

// MARK: - Smart Notification Engine
// Learns the user's habitual entry time and schedules a nudge 15 min before.
// Per PRD: "La app aprende la hora habitual del usuario y envia nudge suave 15 min antes"

final class SmartNotificationService {
    static let shared = SmartNotificationService()
    private init() {}

    private let reminderIdentifier = "daily_gratitude_reminder"
    private let nudgeIdentifier = "smart_nudge_reminder"

    // MARK: - Habit Detection

    /// Analyze the last N entries to detect the user's habitual entry hour
    @MainActor
    func detectHabitualHour(context: ModelContext, lookbackDays: Int = 14) -> Int? {
        let since = Calendar.current.date(byAdding: .day, value: -lookbackDays, to: Date()) ?? Date()

        let descriptor = FetchDescriptor<GratitudeEntry>(
            predicate: #Predicate<GratitudeEntry> { entry in
                entry.createdAt >= since
            }
        )
        let entries = (try? context.fetch(descriptor)) ?? []
        guard entries.count >= 5 else { return nil } // Need minimum data

        // Find the most common hour
        let hours = entries.map { Calendar.current.component(.hour, from: $0.createdAt) }
        let hourCounts = Dictionary(grouping: hours, by: { $0 }).mapValues(\.count)
        return hourCounts.max { $0.value < $1.value }?.key
    }

    // MARK: - Scheduling

    /// Schedule a smart nudge 15 minutes before the user's usual time
    @MainActor
    func scheduleSmartNudge(userName: String, context: ModelContext) {
        guard let habitualHour = detectHabitualHour(context: context) else {
            return // Not enough data yet
        }

        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [nudgeIdentifier])

        let content = UNMutableNotificationContent()
        let nudges = [
            "Tu momento se acerca, \(userName). ¿Algo bueno del día? 🌿",
            "Hola \(userName), tu coach te espera en unos minutos. ✨",
            "\(userName), un pequeño ritual te está esperando. 🙏",
        ]
        content.body = nudges.randomElement() ?? nudges[0]
        content.sound = .default
        content.interruptionLevel = .passive // Don't break focus

        // 15 minutes before habitual hour
        var components = DateComponents()
        let minuteBefore = 45 // hour - 0:15 = previous hour :45
        if habitualHour > 0 {
            components.hour = habitualHour - 1
            components.minute = minuteBefore
        } else {
            components.hour = 23
            components.minute = minuteBefore
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: nudgeIdentifier,
            content: content,
            trigger: trigger
        )
        center.add(request)
    }

    // MARK: - Streak Protection Notification

    /// If user has an active streak and hasn't written today, send a gentle reminder at night
    func scheduleStreakProtection(userName: String, currentStreak: Int) {
        guard currentStreak >= 3 else { return } // Only for meaningful streaks

        let center = UNUserNotificationCenter.current()
        let identifier = "streak_protection"
        center.removePendingNotificationRequests(withIdentifiers: [identifier])

        let content = UNMutableNotificationContent()
        content.body = "\(userName), tu racha de \(currentStreak) días te está esperando. Un momento es suficiente. 🔥"
        content.sound = .default
        content.interruptionLevel = .timeSensitive

        var components = DateComponents()
        components.hour = 22
        components.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        center.add(request)
    }

    /// Cancel protection if user has already written today
    func cancelStreakProtection() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["streak_protection"])
    }

    // MARK: - Milestone Notification

    func sendMilestoneNotification(streak: Int, userName: String) {
        let content = UNMutableNotificationContent()

        switch streak {
        case 7:
            content.title = "Una semana de gratitud 🌱"
            content.body = "\(userName), 7 días seguidos. Algo está tomando raíz."
        case 30:
            content.title = "Un mes contigo mismo 🌳"
            content.body = "\(userName), 30 días. Esto ya no es una app — es un hábito."
        case 100:
            content.title = "100 días ✨"
            content.body = "\(userName), has construido algo raro y valioso. Gracias por confiar."
        default:
            return
        }
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "milestone_\(streak)",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }
}
