import SwiftUI
import Charts

// MARK: - Sentiment Chart
// Per PRD Section 3.5: "Grafica suave de sentimiento promedio en el tiempo
// (no fria, no estilo analytics)"

struct SentimentChartView: View {
    @Environment(\.colorScheme) private var colorScheme
    let points: [SentimentPoint]

    private var average: Double {
        guard !points.isEmpty else { return 0.5 }
        return points.map(\.value).reduce(0, +) / Double(points.count)
    }

    private var trendDescription: String {
        guard points.count >= 4 else {
            return "Sigue escribiendo y aparecerá tu tendencia."
        }
        let halfIndex = points.count / 2
        let firstHalf = points.prefix(halfIndex).map(\.value).reduce(0, +) / Double(halfIndex)
        let secondHalf = points.suffix(points.count - halfIndex).map(\.value).reduce(0, +) / Double(points.count - halfIndex)
        let diff = secondHalf - firstHalf

        switch diff {
        case 0.08...:
            return "Tu tono se ha iluminado en las últimas semanas."
        case ...(-0.08):
            return "Has notado momentos más reflexivos recientemente — eso también cuenta."
        default:
            return "Mantienes un tono emocional estable y presente."
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
                Text("TONO EMOCIONAL — 30 DÍAS")
                    .sereneSectionHeader()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
                Spacer()
                if !points.isEmpty {
                    Text(String(format: "%.0f%%", average * 100))
                        .sereneLabel()
                        .foregroundColor(SereneColors.sage(colorScheme))
                }
            }

            if points.count < 3 {
                emptyState
            } else {
                chart
                Text(trendDescription)
                    .sereneMicro()
                    .foregroundColor(SereneColors.textSecondary(colorScheme))
                    .italic()
            }
        }
        .padding(Spacing.md)
        .sereneSurface()
    }

    private var chart: some View {
        Chart(points) { point in
            LineMark(
                x: .value("Fecha", point.date),
                y: .value("Tono", point.value)
            )
            .foregroundStyle(SereneColors.sage(colorScheme))
            .interpolationMethod(.catmullRom)
            .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round))

            AreaMark(
                x: .value("Fecha", point.date),
                yStart: .value("Piso", 0),
                yEnd: .value("Tono", point.value)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        SereneColors.sage(colorScheme).opacity(0.25),
                        SereneColors.sage(colorScheme).opacity(0.02),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .interpolationMethod(.catmullRom)
        }
        .chartYScale(domain: 0...1)
        .chartYAxis {
            AxisMarks(position: .leading, values: [0.25, 0.5, 0.75]) { _ in
                AxisGridLine()
                    .foregroundStyle(SereneColors.borderDefault(colorScheme).opacity(0.4))
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 7)) { value in
                AxisValueLabel(format: .dateTime.day())
                    .foregroundStyle(SereneColors.textTertiary(colorScheme))
            }
        }
        .frame(height: 140)
    }

    private var emptyState: some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: "waveform.path")
                .font(.system(size: 24))
                .foregroundColor(SereneColors.textTertiary(colorScheme))
            Text("Tu gráfica aparecerá con más entradas")
                .sereneBody()
                .foregroundColor(SereneColors.textSecondary(colorScheme))
        }
        .frame(maxWidth: .infinity, minHeight: 120)
    }
}

#Preview {
    let points: [SentimentPoint] = (0..<30).map { i in
        SentimentPoint(
            date: Calendar.current.date(byAdding: .day, value: -(29 - i), to: Date())!,
            value: 0.4 + Double(i % 5) * 0.1 + Double(i) * 0.01,
            entryCount: 1
        )
    }
    return SentimentChartView(points: points)
        .padding()
}
