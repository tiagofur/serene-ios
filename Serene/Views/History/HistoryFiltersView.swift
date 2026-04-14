import SwiftUI

// MARK: - History Filters Sheet
// Filter by date range, mood, and extras-only

struct HistoryFilter: Equatable {
    var startDate: Date?
    var endDate: Date?
    var selectedMood: String?
    var extrasOnly: Bool = false

    var isActive: Bool {
        startDate != nil || endDate != nil || selectedMood != nil || extrasOnly
    }

    static let empty = HistoryFilter()
}

struct HistoryFiltersView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss

    @Binding var filter: HistoryFilter

    @State private var useDateRange = false
    @State private var startDate = Date()
    @State private var endDate = Date()

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    dateSection
                    moodSection
                    typeSection
                }
                .padding(Spacing.lg)
            }
            .background(SereneColors.background(colorScheme))
            .navigationTitle("Filtros")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Limpiar") {
                        filter = .empty
                        useDateRange = false
                    }
                    .foregroundColor(SereneColors.rosa(colorScheme))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Aplicar") {
                        if useDateRange {
                            filter.startDate = startDate
                            filter.endDate = endDate
                        } else {
                            filter.startDate = nil
                            filter.endDate = nil
                        }
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(SereneColors.sage(colorScheme))
                }
            }
            .onAppear {
                if let s = filter.startDate, let e = filter.endDate {
                    startDate = s
                    endDate = e
                    useDateRange = true
                }
            }
        }
    }

    // MARK: - Date Section
    private var dateSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("RANGO DE FECHAS")
                .sereneSectionHeader()
                .foregroundColor(SereneColors.textTertiary(colorScheme))

            Toggle(isOn: $useDateRange) {
                Text("Filtrar por fecha")
                    .sereneBody()
                    .foregroundColor(SereneColors.textPrimary(colorScheme))
            }
            .tint(SereneColors.sage(colorScheme))

            if useDateRange {
                VStack(spacing: Spacing.sm) {
                    DatePicker("Desde", selection: $startDate, displayedComponents: .date)
                        .foregroundColor(SereneColors.textPrimary(colorScheme))

                    DatePicker("Hasta", selection: $endDate, in: startDate..., displayedComponents: .date)
                        .foregroundColor(SereneColors.textPrimary(colorScheme))
                }
                .padding(Spacing.md)
                .sereneSurface()
            }
        }
    }

    // MARK: - Mood Section
    private var moodSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("ESTADO DE ÁNIMO")
                .sereneSectionHeader()
                .foregroundColor(SereneColors.textTertiary(colorScheme))

            HStack(spacing: Spacing.sm) {
                ForEach(GratitudeMood.allCases) { mood in
                    Button {
                        filter.selectedMood = filter.selectedMood == mood.rawValue ? nil : mood.rawValue
                    } label: {
                        Text(mood.rawValue)
                            .font(.system(size: 22))
                            .frame(width: 40, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: Radius.md)
                                    .fill(filter.selectedMood == mood.rawValue
                                          ? SereneColors.sageSoft(colorScheme)
                                          : Color.clear)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: Radius.md)
                                    .stroke(filter.selectedMood == mood.rawValue
                                            ? SereneColors.sage(colorScheme)
                                            : SereneColors.borderDefault(colorScheme),
                                            lineWidth: filter.selectedMood == mood.rawValue
                                                       ? BorderWidth.emphasis : BorderWidth.default)
                            )
                    }
                }
            }
        }
    }

    // MARK: - Type Section
    private var typeSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("TIPO")
                .sereneSectionHeader()
                .foregroundColor(SereneColors.textTertiary(colorScheme))

            Toggle(isOn: $filter.extrasOnly) {
                HStack {
                    Text("Solo extras desbloqueados")
                        .sereneBody()
                        .foregroundColor(SereneColors.textPrimary(colorScheme))
                    Image(systemName: "sparkles")
                        .foregroundColor(SereneColors.arena(colorScheme))
                }
            }
            .tint(SereneColors.sage(colorScheme))
        }
    }
}

#Preview {
    HistoryFiltersView(filter: .constant(.empty))
}
