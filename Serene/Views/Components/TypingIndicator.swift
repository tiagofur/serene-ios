import SwiftUI

struct TypingIndicator: View {
    @State private var dotScale: [CGFloat] = [1, 1, 1]

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Image(systemName: "leaf.fill")
                .font(.caption2)
                .foregroundStyle(.white)
                .frame(width: 20, height: 20)
                .background(Color.sage)
                .clipShape(Circle())

            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color.textTertiary)
                        .frame(width: 6, height: 6)
                        .scaleEffect(dotScale[index])
                }
            }
            .padding(.top, 7)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.sageSoft)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onAppear { startAnimation() }
    }

    private func startAnimation() {
        for i in 0..<3 {
            withAnimation(
                .easeInOut(duration: 0.35)
                .repeatForever(autoreverses: true)
                .delay(Double(i) * 0.12)
            ) {
                dotScale[i] = 0.5
            }
        }
    }
}

#Preview {
    TypingIndicator()
        .padding()
}
