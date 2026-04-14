import SwiftUI

// MARK: - Unexpected Connections Card
// Per PRD: "Notamos que cuando agradeces naturaleza, tu semana mejora"

struct ConnectionsView: View {
    @Environment(\.colorScheme) private var colorScheme
    let connections: [EmotionalConnection]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "link.circle")
                    .foregroundColor(SereneColors.rosa(colorScheme))
                Text("CONEXIONES INESPERADAS")
                    .sereneSectionHeader()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
            }

            if connections.isEmpty {
                Text("A medida que escribas, tu coach notará qué temas te iluminan más.")
                    .sereneBody()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
                    .padding(.vertical, Spacing.sm)
            } else {
                ForEach(connections) { connection in
                    connectionRow(connection)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.md)
        .sereneSurface()
    }

    private func connectionRow(_ connection: EmotionalConnection) -> some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(SereneColors.rosaSoft(colorScheme))
                    .frame(width: 36, height: 36)
                Text(connection.topic.prefix(1).uppercased())
                    .sereneLabel()
                    .foregroundColor(SereneColors.rosa(colorScheme))
            }

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(connection.topic)
                    .sereneLabel()
                    .foregroundColor(SereneColors.textPrimary(colorScheme))

                Text(connection.narrative)
                    .sereneMicro()
                    .foregroundColor(SereneColors.textSecondary(colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(.vertical, Spacing.xs)
    }
}

#Preview {
    ConnectionsView(connections: [
        EmotionalConnection(
            topic: "Naturaleza",
            sentimentLift: 0.18,
            occurrences: 6,
            narrative: "Cuando mencionas naturaleza, tu tono emocional es más luminoso. Ha aparecido 6 veces en los últimos 30 días."
        ),
        EmotionalConnection(
            topic: "Familia",
            sentimentLift: 0.11,
            occurrences: 4,
            narrative: "Cuando mencionas familia, tu tono emocional es más luminoso. Ha aparecido 4 veces en los últimos 30 días."
        ),
    ])
    .padding()
}
