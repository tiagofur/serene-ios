import SwiftUI
import SwiftData

struct InsightsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appState: AppState

    @Query(sort: \WeeklySummaryEntry.createdAt, order: .reverse)
    private var summaries: [WeeklySummaryEntry]

    @Query(sort: \GratitudeEntry.createdAt, order: .reverse)
    private var recentGratitudes: [GratitudeEntry]

    @State private var selectedSummary: WeeklySummaryEntry?
    @State private var isGeneratingSummary = false

    var body: some View {
        NavigationStack {
            ZStack {
                SereneColors.background(colorScheme)
                    .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        activityCalendar
                        weeklySummarySection
                        topTopicsSection
                        sentimentTrendCard

                        if appState.userTier != .pro {
                            proLockedSection
                        } else {
                            historicalSummariesSection
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Insights")
            .sheet(item: $selectedSummary) { summary in
                WeeklySummaryDetailView(summary: summary)
                    .environmentObject(appState)
            }
            .task {
                await maybeGenerateWeeklySummary()
            }
        }
    }

    // MARK: - Auto-generate weekly summary
    private func maybeGenerateWeeklySummary() async {
        // Only generate on Mondays or if there's no summary for this week
        let weekday = Calendar.current.component(.weekday, from: Date())
        let shouldAttempt = weekday == 2 /* Monday */ ||
            (summaries.first?.weekStart != Date().startOfWeek)

        guard shouldAttempt,
              WeeklySummaryService.shared.shouldGenerateSummary(context: modelContext),
              !isGeneratingSummary else { return }

        isGeneratingSummary = true
        _ = await WeeklySummaryService.shared.generateWeeklySummary(
            userName: appState.userName,
            isPro: appState.userTier == .pro,
            context: modelContext
        )
        isGeneratingSummary = false
    }

    // MARK: - Activity Calendar
    private var activityCalendar: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("ACTIVIDAD — ÚLTIMOS 30 DÍAS")
                .sereneSectionHeader()
                .foregroundColor(SereneColors.textTertiary(colorScheme))

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 10), spacing: 3) {
                ForEach(0..<30, id: \.self) { dayOffset in
                    let date = Calendar.current.date(byAdding: .day, value: -(29 - dayOffset), to: Date())!
                    let count = gratitudeCount(for: date)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(activityColor(count: count))
                        .frame(height: 18)
                }
            }

            HStack(spacing: Spacing.sm) {
                Text("Menos")
                    .sereneMicro()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
                ForEach([0, 1, 3, 5], id: \.self) { level in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(activityColor(count: level))
                        .frame(width: 10, height: 10)
                }
                Text("Más")
                    .sereneMicro()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
            }
        }
        .padding(Spacing.md)
        .sereneSurface()
    }

    private func gratitudeCount(for date: Date) -> Int {
        let calendar = Calendar.current
        return recentGratitudes.filter { calendar.isDate($0.createdAt, inSameDayAs: date) }.count
    }

    private func activityColor(count: Int) -> Color {
        switch count {
        case 0: return SereneColors.surface(colorScheme)
        case 1...2: return SereneColors.sageSoft(colorScheme)
        case 3...4: return SereneColors.sage(colorScheme).opacity(0.6)
        default: return SereneColors.sage(colorScheme)
        }
    }

    // MARK: - Weekly Summary
    @ViewBuilder
    private var weeklySummarySection: some View {
        if let latest = summaries.first {
            Button {
                selectedSummary = latest
            } label: {
                weeklySummaryCard(latest)
            }
            .buttonStyle(SerenePressableStyle())
        } else {
            weeklySummaryPlaceholder
        }
    }

    private func weeklySummaryCard(_ summary: WeeklySummaryEntry) -> some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Image(systemName: "text.bubble")
                    .foregroundColor(SereneColors.sage(colorScheme))
                Text("RESUMEN SEMANAL")
                    .sereneSectionHeader()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
                Spacer()
                Text(summary.dominantEmoji)
                    .font(.system(size: 24))
            }

            Text(summary.narrative)
                .sereneBody()
                .foregroundColor(SereneColors.textPrimary(colorScheme))
                .multilineTextAlignment(.leading)
                .lineLimit(4)

            if !summary.topTopics.isEmpty {
                HStack(spacing: Spacing.sm) {
                    ForEach(summary.topTopics.prefix(3), id: \.self) { topic in
                        Text(topic)
                            .sereneMicro()
                            .foregroundColor(SereneColors.sage(colorScheme))
                            .padding(.horizontal, Spacing.sm)
                            .padding(.vertical, Spacing.xs)
                            .background(Capsule().fill(SereneColors.sageSoft(colorScheme)))
                    }
                }
            }

            HStack {
                Spacer()
                Text("Ver completo")
                    .sereneMicro()
                    .foregroundColor(SereneColors.sage(colorScheme))
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(SereneColors.sage(colorScheme))
            }
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Radius.md)
                .fill(SereneColors.cardElevated(colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .stroke(SereneColors.sage(colorScheme).opacity(0.25), lineWidth: 1)
                )
        )
    }

    private var weeklySummaryPlaceholder: some View {
        VStack(spacing: Spacing.md) {
            if isGeneratingSummary {
                ProgressView()
                    .tint(SereneColors.sage(colorScheme))
                Text("Tu coach está preparando tu resumen...")
                    .sereneBody()
                    .foregroundColor(SereneColors.textSecondary(colorScheme))
            } else {
                Image(systemName: "text.bubble")
                    .font(.system(size: 28))
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
                Text("Tu primer resumen semanal aparecerá aquí")
                    .sereneBody()
                    .foregroundColor(SereneColors.textSecondary(colorScheme))
                    .multilineTextAlignment(.center)
                Text("Sigue escribiendo gratitudes y tu coach preparará un resumen personalizado cada lunes")
                    .sereneMicro()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: Radius.md)
                .fill(SereneColors.surface(colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .stroke(SereneColors.borderDefault(colorScheme),
                                style: StrokeStyle(lineWidth: 1, dash: [5, 3]))
                )
        )
    }

    // MARK: - Historical Summaries (Pro)
    private var historicalSummariesSection: some View {
        Group {
            if summaries.count > 1 {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("RESÚMENES ANTERIORES")
                        .sereneSectionHeader()
                        .foregroundColor(SereneColors.textTertiary(colorScheme))

                    ForEach(summaries.dropFirst().prefix(5)) { summary in
                        Button {
                            selectedSummary = summary
                        } label: {
                            HStack(spacing: Spacing.md) {
                                Text(summary.dominantEmoji)
                                    .font(.system(size: 22))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(weekRangeText(for: summary))
                                        .sereneLabel()
                                        .foregroundColor(SereneColors.textPrimary(colorScheme))
                                    Text(summary.narrative)
                                        .sereneMicro()
                                        .foregroundColor(SereneColors.textSecondary(colorScheme))
                                        .lineLimit(1)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(SereneColors.textTertiary(colorScheme))
                            }
                            .padding(Spacing.md)
                            .sereneSurface()
                        }
                        .buttonStyle(SerenePressableStyle())
                    }
                }
            }
        }
    }

    private func weekRangeText(for summary: WeeklySummaryEntry) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es")
        formatter.dateFormat = "d MMM"
        let end = Calendar.current.date(byAdding: .day, value: 6, to: summary.weekStart) ?? summary.weekStart
        return "\(formatter.string(from: summary.weekStart)) — \(formatter.string(from: end))"
    }

    // MARK: - Top Topics
    private var topTopicsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("TEMAS RECURRENTES")
                .sereneSectionHeader()
                .foregroundColor(SereneColors.textTertiary(colorScheme))

            if recentGratitudes.isEmpty {
                Text("Escribe algunas gratitudes para ver tus temas")
                    .sereneBody()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
            } else {
                let topics = extractTopTopics()
                if topics.isEmpty {
                    Text("Aún no hay suficiente contenido para detectar patrones")
                        .sereneBody()
                        .foregroundColor(SereneColors.textTertiary(colorScheme))
                } else {
                    ForEach(topics, id: \.0) { topic, count in
                        HStack {
                            Text(topic)
                                .sereneBody()
                                .foregroundColor(SereneColors.textPrimary(colorScheme))
                            Spacer()
                            Text("\(count)x")
                                .sereneLabel()
                                .foregroundColor(SereneColors.textTertiary(colorScheme))
                        }
                        .padding(.vertical, Spacing.xs)
                    }
                }
            }
        }
        .padding(Spacing.md)
        .sereneSurface()
    }

    private func extractTopTopics() -> [(String, Int)] {
        let stopWords: Set<String> = [
            "hoy", "agradezco", "por", "que", "una", "uno", "del", "los", "las",
            "con", "para", "como", "más", "muy", "fue", "ser", "este", "esta",
            "eso", "esa", "tengo", "estar", "también", "había",
        ]
        var wordCounts: [String: Int] = [:]

        for entry in recentGratitudes.prefix(50) {
            let words = entry.text.lowercased()
                .components(separatedBy: .alphanumerics.inverted)
                .filter { $0.count > 3 && !stopWords.contains($0) }
            for word in words {
                wordCounts[word, default: 0] += 1
            }
        }

        return wordCounts.sorted { $0.value > $1.value }
            .prefix(3)
            .map { ($0.key.capitalized, $0.value) }
    }

    // MARK: - Sentiment Trend
    private var sentimentTrendCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("TENDENCIA EMOCIONAL")
                .sereneSectionHeader()
                .foregroundColor(SereneColors.textTertiary(colorScheme))

            if recentGratitudes.isEmpty {
                Text("Tu gráfica emocional aparecerá cuando tengas más entradas")
                    .sereneBody()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
            } else {
                let moodCounts = Dictionary(grouping: recentGratitudes.prefix(30)) { $0.emoji }
                    .mapValues { $0.count }
                    .sorted { $0.value > $1.value }

                HStack(spacing: Spacing.md) {
                    ForEach(moodCounts.prefix(5), id: \.key) { emoji, count in
                        VStack(spacing: Spacing.xs) {
                            Text(emoji.isEmpty ? "📝" : emoji)
                                .font(.system(size: 24))
                            Text("\(count)")
                                .sereneLabel()
                                .foregroundColor(SereneColors.textSecondary(colorScheme))
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.md)
        .sereneSurface()
    }

    // MARK: - Pro Locked
    private var proLockedSection: some View {
        VStack(spacing: Spacing.md) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "lock.fill")
                    .foregroundColor(SereneColors.arena(colorScheme))
                Text("Funciones Pro")
                    .sereneHeading(16)
                    .foregroundColor(SereneColors.textPrimary(colorScheme))
            }

            VStack(alignment: .leading, spacing: Spacing.sm) {
                proFeatureRow("Resúmenes semanales ilimitados")
                proFeatureRow("Histórico completo de resúmenes")
                proFeatureRow("Patrones emocionales avanzados")
                proFeatureRow("Conexiones inesperadas entre entradas")
                proFeatureRow("Exportar historial en PDF")
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                // Navigate to subscription
            } label: {
                Text("Desbloquear con Pro")
            }
            .buttonStyle(SerenePrimaryButtonStyle())
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Radius.md)
                .fill(SereneColors.arenaSoft(colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .stroke(SereneColors.arena(colorScheme).opacity(0.3), lineWidth: 1)
                )
        )
    }

    private func proFeatureRow(_ text: String) -> some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "sparkle")
                .font(.system(size: 10))
                .foregroundColor(SereneColors.arena(colorScheme))
            Text(text)
                .sereneBody(13)
                .foregroundColor(SereneColors.textSecondary(colorScheme))
        }
    }
}

extension WeeklySummaryEntry: @retroactive Identifiable {}

#Preview {
    InsightsView()
        .environmentObject(AppState())
}
