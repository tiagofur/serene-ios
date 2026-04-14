import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appState: AppState

    @Query(sort: \GratitudeEntry.createdAt, order: .reverse) private var allGratitudes: [GratitudeEntry]

    @State private var searchText = ""
    @State private var selectedEntry: GratitudeEntry?
    @State private var filter: HistoryFilter = .empty
    @State private var showFilters = false

    // MARK: - Filtered Entries
    private var filteredGratitudes: [GratitudeEntry] {
        var entries: [GratitudeEntry]

        // Free tier: 7 days max
        if appState.userTier == .pro {
            entries = allGratitudes
        } else {
            let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            entries = allGratitudes.filter { $0.createdAt >= sevenDaysAgo }
        }

        // Search
        if !searchText.isEmpty {
            entries = entries.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
        }

        // Date range
        if let start = filter.startDate {
            entries = entries.filter { $0.createdAt >= start.startOfDay }
        }
        if let end = filter.endDate {
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: end.startOfDay) ?? end
            entries = entries.filter { $0.createdAt < endOfDay }
        }

        // Mood
        if let mood = filter.selectedMood {
            entries = entries.filter { $0.emoji == mood }
        }

        // Extras only
        if filter.extrasOnly {
            entries = entries.filter { $0.isExtra }
        }

        return entries
    }

    private var groupedByDate: [(String, [GratitudeEntry])] {
        let grouped = Dictionary(grouping: filteredGratitudes) { entry in
            entry.createdAt.relativeDescription
        }
        return grouped.sorted { lhs, rhs in
            guard let lDate = lhs.value.first?.createdAt,
                  let rDate = rhs.value.first?.createdAt else { return false }
            return lDate > rDate
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                SereneColors.background(colorScheme)
                    .ignoresSafeArea()

                content

                if appState.userTier != .pro && !allGratitudes.isEmpty {
                    proUpgradeBanner
                }
            }
            .navigationTitle("Historial")
            .searchable(text: $searchText, prompt: "Buscar en tus gratitudes...")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFilters = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .foregroundColor(SereneColors.sage(colorScheme))
                            if filter.isActive {
                                Circle()
                                    .fill(SereneColors.arena(colorScheme))
                                    .frame(width: 8, height: 8)
                                    .offset(x: 2, y: -2)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                HistoryFiltersView(filter: $filter)
                    .presentationDetents([.medium, .large])
            }
            .sheet(item: $selectedEntry) { entry in
                HistoryDetailSheet(entry: entry)
                    .presentationDetents([.medium, .large])
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if filteredGratitudes.isEmpty {
            emptyState
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: Spacing.md) {
                    if filter.isActive {
                        filterPills
                    }

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
                                .padding(.leading, Spacing.xs)
                        }
                    }
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, 120)
            }
        }
    }

    // MARK: - Filter Pills
    private var filterPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.sm) {
                if let start = filter.startDate, let end = filter.endDate {
                    FilterPill(
                        icon: "calendar",
                        text: "\(start.formatted(date: .abbreviated, time: .omitted)) — \(end.formatted(date: .abbreviated, time: .omitted))"
                    ) {
                        filter.startDate = nil
                        filter.endDate = nil
                    }
                }
                if let mood = filter.selectedMood {
                    FilterPill(emoji: mood, text: "Mood") {
                        filter.selectedMood = nil
                    }
                }
                if filter.extrasOnly {
                    FilterPill(icon: "sparkles", text: "Solo extras") {
                        filter.extrasOnly = false
                    }
                }
            }
            .padding(.vertical, Spacing.sm)
        }
    }

    // MARK: - Empty
    private var emptyState: some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: filter.isActive ? "magnifyingglass" : "book.closed")
                .font(.system(size: 40))
                .foregroundColor(SereneColors.textTertiary(colorScheme))
            Text(filter.isActive ? "Sin resultados" : "Tu historial está vacío")
                .sereneHeading(18)
                .foregroundColor(SereneColors.textPrimary(colorScheme))
            Text(filter.isActive
                 ? "Intenta ajustar los filtros"
                 : "Las gratitudes que escribas aparecerán aquí")
                .sereneBody()
                .foregroundColor(SereneColors.textSecondary(colorScheme))
                .multilineTextAlignment(.center)
        }
        .padding(Spacing.xl)
    }

    // MARK: - Upgrade Banner
    private var proUpgradeBanner: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "crown.fill")
                .font(.system(size: 14))
                .foregroundColor(SereneColors.arena(colorScheme))
            Text("Historial completo con Pro")
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

// MARK: - Filter Pill
struct FilterPill: View {
    @Environment(\.colorScheme) private var colorScheme
    var icon: String? = nil
    var emoji: String? = nil
    let text: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: Spacing.xs) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 11))
            }
            if let emoji {
                Text(emoji)
                    .font(.system(size: 12))
            }
            Text(text)
                .sereneMicro()
            Image(systemName: "xmark")
                .font(.system(size: 9, weight: .bold))
        }
        .foregroundColor(SereneColors.sage(colorScheme))
        .padding(.horizontal, Spacing.sm + 2)
        .padding(.vertical, 6)
        .background(Capsule().fill(SereneColors.sageSoft(colorScheme)))
        .onTapGesture(perform: onRemove)
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
                        .background(Capsule().fill(SereneColors.arenaSoft(colorScheme)))
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
        .sereneSurface()
    }
}

// MARK: - History Detail Sheet
struct HistoryDetailSheet: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    let entry: GratitudeEntry

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text(entry.createdAt.formatted(date: .long, time: .shortened))
                            .sereneLabel()
                            .foregroundColor(SereneColors.textTertiary(colorScheme))
                        if !entry.emoji.isEmpty {
                            Text(entry.emoji)
                                .font(.system(size: 36))
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
            }
            .padding(Spacing.lg)
        }
        .background(SereneColors.background(colorScheme))
    }
}

extension GratitudeEntry: @retroactive Identifiable {}

#Preview {
    HistoryView()
        .environmentObject(AppState())
}
