import SwiftUI

struct CoachReplyBubble: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            // Coach avatar
            Image(systemName: "leaf.fill")
                .font(.caption2)
                .foregroundStyle(.white)
                .frame(width: 20, height: 20)
                .background(Color.sage)
                .clipShape(Circle())

            Text(text)
                .font(.bodySmall)
                .foregroundStyle(Color.textSecondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.sageSoft)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    CoachReplyBubble(text: "Que bonito es reconocer los pequenos momentos que te hacen feliz.")
        .padding()
}
