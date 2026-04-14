import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appState: AppState

    @Query(sort: \GratitudeEntry.createdAt, order: .reverse) private var allGratitudes: [GratitudeEntry]
    @State private var searchText = ""
    @State private var selectedEntry: GratitudeEntry?

    private var filteredGratitudes: [GratitudeEntry] {
        let entries: [GratitudeEntry]
        if appState.userTier == .pro {
            entries = allGratitudes
        } else {
            // Free: only 7 days of history
            let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            entries = allGratitudes.filter { $0.createdAt >= sevenDaysAgo }
        }

        if searchText.isEmpty {
            return entries
        }
        return entries.filter {
            $0.text.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var groupedByDate: [(String, [GratitudeEntry])] {
        let grouped = Dictionary(grouping: filteredGratitudes) { entry in
            entry.createdAt.formatted(date: .long, time: .omitted)
        }
        return grouped.sorted { lhs, rhs in
            guard let lDate = lhs.value.first?.createdAt,
                  let rDate = rhs.value.first?.createdAt else { return false }
            return lDate > rDate
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                SereneColors.background(colorScheme)
                    .ignoresSafeArea()

                if filteredGratitudes.isEmpty {
                    emptyState
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(alignment: .leading, spacing: Spacing.lg) {
                            ForEach(groupedByDate, id: \.0) { date, entries in
                                Section {
                                    ForEach(entries, id: \.id) { entry in
                                        HistoryEntryCard(entry: entry)
                                            .onTapGesture {
                                                selectedEntry = entry
                                            }
                                    }
                                } header: {
                                    Text(date)
                                        .sereneSectionHeader()
                                        .foregroundColor(SereneColors.textTertiary(colorScheme))
                                        .padding(.top, Spacing.sm)
                                }
                            }
                        }
                        .padding(.horizontal, Spacing.lg)
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Historial")
            .searchable(text: $searchText, prompt: "Buscar gratitudes...")
            .sheet(item: $selectedEntry) { entry in
                HistoryDetailSheet(entry: entry)
                    .presentationDetents([.medium, .large])
            }

            if appState.userTier != .pro {
                proUpgradeBanner
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: "book.closed")
                .font(.system(size: 40))
                .foregroundColor(SereneColors.textTertiary(colorScheme))
            Text("Tu historial está vacío")
                .sereneHeading(18)
                .foregroundColor(SereneColors.textPrimary(colorScheme))
            Text("Las gratitudes que escribas aparecerán aquí")
                .sereneBody()
                .foregroundColor(SereneColors.textSecondary(colorScheme))
        }
    }

    private var proUpgradeBanner: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "crown.fill")
                .font(.system(size: 14))
                .foregroundColor(SereneColors.arena(colorScheme))
            Text("Historial completo disponible con Pro")
                .sereneLabel()
                .foregroundColor(SereneColors.textSecondary(colorScheme))
            Spacer()
            Text("Ver más")
                .sereneLabel()
                .foregroundColor(SereneColors.sage(colorScheme))
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Radius.md)
                .fill(SereneColors.arenaSoft(colorScheme))
        )
        .padding(.horizontal, Spacing.lg)
        .padding(.bottom, Spacing.sm)
    }
}

// MARK: - History Entry Card
struct HistoryEntryCard: View {
    @Environment(\.colorScheme) private var colorScheme
    let entry: GratitudeEntry

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                if !entry.emoji.isEmpty {
                    Text(entry.emoji)
                        .font(.system(size: 16))
                }
                Text(entry.createdAt.formatted(date: .omitted, time: .shortened))
                    .sereneMicro()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
                Spacer()
                if entry.isExtra {
                    Text("EXTRA")
                        .sereneMicro()
                        .foregroundColor(SereneColors.arena(colorScheme))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(SereneColors.arenaSoft(colorScheme))
                        )
                }
            }

            Text(entry.text)
                .sereneBody()
                .foregroundColor(SereneColors.textPrimary(colorScheme))
                .lineLimit(3)

            if let response = entry.aiResponse, !response.isEmpty {
                CoachReplyView(text: response)
            }
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Radius.md)
                .fill(SereneColors.surface(colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .stroke(SereneColors.borderDefault(colorScheme), lineWidth: BorderWidth.default)
                )
        )
    }
}

// MARK: - History Detail Sheet
struct HistoryDetailSheet: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    let entry: GratitudeEntry

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(entry.createdAt.formatted(date: .long, time: .shortened))
                        .sereneLabel()
                        .foregroundColor(SereneColors.textTertiary(colorScheme))
                    if !entry.emoji.isEmpty {
                        Text(entry.emoji)
                            .font(.system(size: 28))
                    }
                }
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(SereneColors.textSecondary(colorScheme))
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(SereneColors.surface(colorScheme)))
                }
            }

            Text(entry.text)
                .sereneBody()
                .foregroundColor(SereneColors.textPrimary(colorScheme))

            if let response = entry.aiResponse, !response.isEmpty {
                Divider()
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    HStack(spacing: Spacing.sm) {
                        ZStack {
                            Circle()
                                .fill(SereneColors.sage(colorScheme))
                                .frame(width: 24, height: 24)
                            Image(systemName: "sparkle")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                        Text("Respuesta del coach")
                            .sereneLabel()
                            .foregroundColor(SereneColors.sage(colorScheme))
                    }
                    Text(response)
                        .sereneBody()
                        .foregroundColor(SereneColors.textSecondary(colorScheme))
                }
            }

            Spacer()
        }
        .padding(Spacing.lg)
        .background(SereneColors.background(colorScheme))
    }
}

extension GratitudeEntry: @retroactive Identifiable {}

#Preview {
    HistoryView()
        .environmentObject(AppState())
}
