import SwiftUI

struct StreakDotsView: View {
    let currentDay: Int // 0-6 (Mon-Sun)
    let completedDays: Set<Int>

    var body: some View {
        HStack(spacing: Spacing.sm) {
            ForEach(0..<7, id: \.self) { day in
                Circle()
                    .fill(dotColor(for: day))
                    .frame(width: 8, height: 8)
                    .overlay {
                        if !completedDays.contains(day) && day != currentDay {
                            Circle()
                                .stroke(Color.borderDefault, lineWidth: 1)
                        }
                    }
            }
        }
    }

    private func dotColor(for day: Int) -> Color {
        if completedDays.contains(day) {
            return .sage
        } else if day == currentDay {
            return .arena
        }
        return .clear
    }
}

#Preview {
    StreakDotsView(currentDay: 3, completedDays: [0, 1, 2])
        .padding()
}
