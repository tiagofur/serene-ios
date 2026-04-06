import SwiftUI
import SwiftData

struct HistoryView: View {
    @EnvironmentObject private var appState: AppState
    @Query(sort: \Gratitude.createdAt, order: .reverse) private var gratitudes: [Gratitude]
    @State private var searchText = ""

    private var filteredGratitudes: [Gratitude] {
        if searchText.isEmpty {
            return gratitudes
        }
        return gratitudes.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
    }

    private var groupedByDate: [(String, [Gratitude])] {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "es")

        let grouped = Dictionary(grouping: filteredGratitudes) { gratitude in
            formatter.string(from: gratitude.createdAt)
        }

        return grouped.sorted { lhs, rhs in
            guard let lhsDate = lhs.value.first?.createdAt,
                  let rhsDate = rhs.value.first?.createdAt else { return false }
            return lhsDate > rhsDate
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedByDate, id: \.0) { date, entries in
                    Section {
                        ForEach(entries) { gratitude in
                            HistoryRow(gratitude: gratitude)
                        }
                    } header: {
                        Text(date)
                            .font(.label)
                            .foregroundStyle(Color.textTertiary)
                    }
                }
                .listRowBackground(Color.surface)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.backgroundPrimary)
            .navigationTitle("Historial")
            .searchable(text: $searchText, prompt: "Buscar en tus gratitudes")
        }
    }
}

struct HistoryRow: View {
    let gratitude: Gratitude

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text(gratitude.emoji.symbol)
                Text(gratitude.text)
                    .font(.body)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(2)
            }

            if let response = gratitude.aiResponse {
                CoachReplyBubble(text: response)
            }

            Text(gratitude.createdAt, style: .time)
                .font(.micro)
                .foregroundStyle(Color.textTertiary)
        }
        .padding(.vertical, Spacing.xs)
    }
}

#Preview {
    HistoryView()
        .environmentObject(AppState())
}
