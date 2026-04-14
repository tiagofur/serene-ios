import Foundation

extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }

    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }

    func daysAgo(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: self) ?? self
    }

    var relativeDescription: String {
        if isToday {
            return "Hoy"
        } else if isYesterday {
            return "Ayer"
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "es")
            formatter.dateStyle = .medium
            return formatter.string(from: self)
        }
    }
}
