import SwiftUI
import SwiftData
import UIKit

// MARK: - Export PDF Button
// Pro feature: exports filtered history as a formatted PDF

struct ExportPDFButton: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var appState: AppState
    let entries: [GratitudeEntry]

    @State private var isExporting = false
    @State private var exportedURL: URL?
    @State private var showShareSheet = false

    var body: some View {
        Button {
            exportPDF()
        } label: {
            HStack(spacing: Spacing.sm) {
                if isExporting {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(SereneColors.sage(colorScheme))
                } else {
                    Image(systemName: "square.and.arrow.up")
                }
                Text(isExporting ? "Generando..." : "Exportar a PDF")
            }
            .sereneLabel()
            .foregroundColor(SereneColors.sage(colorScheme))
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(Capsule().fill(SereneColors.sageSoft(colorScheme)))
        }
        .disabled(isExporting || entries.isEmpty)
        .sheet(isPresented: $showShareSheet) {
            if let url = exportedURL {
                ShareSheet(items: [url])
            }
        }
    }

    private func exportPDF() {
        guard !entries.isEmpty else { return }
        isExporting = true

        Task {
            let dateRange: ClosedRange<Date>? = {
                guard let minDate = entries.map(\.createdAt).min(),
                      let maxDate = entries.map(\.createdAt).max() else { return nil }
                return minDate...maxDate
            }()

            let url = PDFExportService.shared.exportGratitudes(
                entries,
                userName: appState.userName,
                dateRange: dateRange
            )

            await MainActor.run {
                isExporting = false
                if let url {
                    exportedURL = url
                    showShareSheet = true
                }
            }
        }
    }
}
