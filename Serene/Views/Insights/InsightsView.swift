import SwiftUI

struct InsightsView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    // Weekly summary card
                    weeklySummaryCard

                    // Activity calendar placeholder
                    activityCalendar

                    // Top topics
                    topTopicsSection
                }
                .padding(Spacing.md)
            }
            .background(Color.backgroundPrimary)
            .navigationTitle("Insights")
        }
    }

    private var weeklySummaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundStyle(Color.sage)
                Text("Resumen semanal")
                    .font(.headingSmall)
                    .foregroundStyle(Color.textPrimary)
            }

            Text("Tu resumen estara disponible el lunes.")
                .font(.body)
                .foregroundStyle(Color.textSecondary)
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }

    private var activityCalendar: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("ACTIVIDAD — 30 DIAS")
                .font(.labelSmall)
                .fontWeight(.semibold)
                .tracking(0.72)
                .foregroundStyle(Color.textTertiary)

            // Grid placeholder (GitHub-style contributions)
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(12), spacing: 3), count: 7), spacing: 3) {
                ForEach(0..<30, id: \.self) { day in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.surface)
                        .frame(height: 12)
                }
            }
        }
        .padding(Spacing.md)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }

    private var topTopicsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("TEMAS FRECUENTES")
                .font(.labelSmall)
                .fontWeight(.semibold)
                .tracking(0.72)
                .foregroundStyle(Color.textTertiary)

            Text("Escribe mas gratitudes para descubrir tus temas recurrentes.")
                .font(.body)
                .foregroundStyle(Color.textSecondary)
        }
        .padding(Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
    }
}

#Preview {
    InsightsView()
        .environmentObject(AppState())
}
