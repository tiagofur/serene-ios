import SwiftUI
import UIKit

// MARK: - Weekly Summary Detail View
// Shown when user taps a summary card. Supports share-as-image.

struct WeeklySummaryDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState

    let summary: WeeklySummaryEntry

    @State private var showShareSheet = false
    @State private var shareImage: UIImage?

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: Spacing.lg) {
                    shareableCard

                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("TEMAS DE LA SEMANA")
                            .sereneSectionHeader()
                            .foregroundColor(SereneColors.textTertiary(colorScheme))

                        ForEach(Array(summary.topTopics.enumerated()), id: \.offset) { index, topic in
                            HStack(spacing: Spacing.md) {
                                Text("\(index + 1)")
                                    .sereneLabel()
                                    .foregroundColor(SereneColors.sage(colorScheme))
                                    .frame(width: 24, height: 24)
                                    .background(Circle().fill(SereneColors.sageSoft(colorScheme)))

                                Text(topic)
                                    .sereneBody()
                                    .foregroundColor(SereneColors.textPrimary(colorScheme))
                                Spacer()
                            }
                        }
                    }
                    .padding(Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: Radius.md)
                            .fill(SereneColors.surface(colorScheme))
                    )

                    Button {
                        captureAndShare()
                    } label: {
                        HStack(spacing: Spacing.sm) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Compartir resumen")
                        }
                        .sereneBody(14)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: Radius.lg)
                                .fill(SereneColors.sage(colorScheme))
                        )
                    }
                }
                .padding(Spacing.lg)
            }
            .background(SereneColors.background(colorScheme))
            .navigationTitle("Tu semana")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") { dismiss() }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                if let image = shareImage {
                    ShareSheet(items: [image])
                }
            }
        }
    }

    // MARK: - Shareable Card
    private var shareableCard: some View {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("RESUMEN SEMANAL")
                        .sereneSectionHeader()
                        .foregroundColor(SereneColors.sage(colorScheme))
                    Text(weekRangeText)
                        .sereneLabel()
                        .foregroundColor(SereneColors.textTertiary(colorScheme))
                }
                Spacer()
                Text(summary.dominantEmoji)
                    .font(.system(size: 36))
            }

            Text(summary.narrative)
                .sereneDisplay(20)
                .foregroundColor(SereneColors.textPrimary(colorScheme))
                .fixedSize(horizontal: false, vertical: true)

            if !summary.topTopics.isEmpty {
                HStack(spacing: Spacing.sm) {
                    ForEach(summary.topTopics, id: \.self) { topic in
                        Text(topic)
                            .sereneLabel()
                            .foregroundColor(SereneColors.sage(colorScheme))
                            .padding(.horizontal, Spacing.md)
                            .padding(.vertical, Spacing.sm)
                            .background(
                                Capsule()
                                    .fill(SereneColors.sageSoft(colorScheme))
                            )
                    }
                }
            }

            HStack {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 10))
                Text("Serene")
                    .sereneMicro()
            }
            .foregroundColor(SereneColors.textTertiary(colorScheme))
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: Radius.xl)
                .fill(SereneColors.cardElevated(colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.xl)
                        .stroke(SereneColors.sage(colorScheme).opacity(0.2), lineWidth: 1)
                )
        )
    }

    private var weekRangeText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es")
        formatter.dateFormat = "d MMM"
        let end = Calendar.current.date(byAdding: .day, value: 6, to: summary.weekStart) ?? summary.weekStart
        return "\(formatter.string(from: summary.weekStart)) — \(formatter.string(from: end))"
    }

    // MARK: - Share
    private func captureAndShare() {
        let renderer = ImageRenderer(content:
            shareableCard
                .frame(width: 340)
                .padding(Spacing.lg)
                .background(SereneColors.background(colorScheme))
        )
        renderer.scale = 3.0
        if let uiImage = renderer.uiImage {
            shareImage = uiImage
            showShareSheet = true
        }
    }
}

// MARK: - UIKit Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
