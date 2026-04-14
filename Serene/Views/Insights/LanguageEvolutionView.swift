import SwiftUI

// MARK: - Language Evolution Card
// Per PRD: "Comparacion de palabras usadas hace 30 dias vs ahora"

struct LanguageEvolutionView: View {
    @Environment(\.colorScheme) private var colorScheme
    let evolution: LanguageEvolution?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "text.magnifyingglass")
                    .foregroundColor(SereneColors.arena(colorScheme))
                Text("EVOLUCIÓN DE TU LENGUAJE")
                    .sereneSectionHeader()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
            }

            if let evolution, !evolution.currentPeriodTopWords.isEmpty {
                if !evolution.newWords.isEmpty {
                    wordGroup(
                        title: "Palabras que aparecieron",
                        words: evolution.newWords,
                        color: SereneColors.sage(colorScheme),
                        softColor: SereneColors.sageSoft(colorScheme)
                    )
                }

                if !evolution.fadingWords.isEmpty {
                    wordGroup(
                        title: "Palabras que se fueron",
                        words: evolution.fadingWords,
                        color: SereneColors.accentEarth(colorScheme),
                        softColor: SereneColors.surface(colorScheme)
                    )
                }

                Divider()
                    .padding(.vertical, Spacing.xs)

                HStack {
                    Text("Vocabulario expandido")
                        .sereneMicro()
                        .foregroundColor(SereneColors.textTertiary(colorScheme))
                    Spacer()
                    Text("+\(evolution.expansionCount) palabras")
                        .sereneLabel()
                        .foregroundColor(SereneColors.sage(colorScheme))
                }
            } else {
                Text("Necesitamos 60 días de entradas para comparar tu lenguaje. Sigue escribiendo.")
                    .sereneBody()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
                    .padding(.vertical, Spacing.sm)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.md)
        .sereneSurface()
    }

    private func wordGroup(title: String, words: [String], color: Color, softColor: Color) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(title)
                .sereneMicro()
                .foregroundColor(SereneColors.textSecondary(colorScheme))

            FlowLayout(spacing: 6) {
                ForEach(words, id: \.self) { word in
                    Text(word)
                        .sereneMicro()
                        .foregroundColor(color)
                        .padding(.horizontal, Spacing.sm + 2)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(softColor))
                }
            }
        }
    }
}

// MARK: - Simple Flow Layout (wraps children like flexbox)
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var totalHeight: CGFloat = 0
        var rowHeight: CGFloat = 0
        var rowWidth: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if rowWidth + size.width > maxWidth {
                totalHeight += rowHeight + spacing
                rowHeight = size.height
                rowWidth = size.width + spacing
            } else {
                rowWidth += size.width + spacing
                rowHeight = max(rowHeight, size.height)
            }
        }
        totalHeight += rowHeight
        return CGSize(width: maxWidth, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            view.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview {
    LanguageEvolutionView(evolution: LanguageEvolution(
        previousPeriodTopWords: ["Familia", "Trabajo", "Sueño"],
        currentPeriodTopWords: ["Naturaleza", "Amigos", "Proyecto"],
        newWords: ["Naturaleza", "Respiración", "Silencio", "Paseo"],
        fadingWords: ["Ansiedad", "Cansancio"],
        expansionCount: 24
    ))
    .padding()
}
