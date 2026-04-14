import SwiftUI

// MARK: - Difficult Mode Conversational View
// Opens when the user taps "No encuentro nada" from the writing sheet.
// A Socratic, gentle chat that helps crystallize a gratitude.

struct DifficultModeView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState

    let onGratitudeCrystallized: (String) -> Void

    @State private var messages: [DifficultModeMessage] = []
    @State private var currentInput: String = ""
    @State private var isTyping: Bool = false
    @State private var suggestedGratitude: String?
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header subtitle
                header

                // Conversation scroll
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: Spacing.md) {
                            ForEach(messages) { message in
                                messageBubble(message)
                                    .id(message.id)
                            }
                            if isTyping {
                                HStack {
                                    TypingDotsView()
                                    Spacer()
                                }
                                .id("typing")
                            }
                            if let suggestion = suggestedGratitude {
                                suggestionCard(suggestion)
                                    .id("suggestion")
                            }
                        }
                        .padding(Spacing.lg)
                    }
                    .onChange(of: messages.count) { _, _ in
                        withAnimation {
                            proxy.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                    }
                    .onChange(of: suggestedGratitude) { _, _ in
                        withAnimation {
                            proxy.scrollTo("suggestion", anchor: .bottom)
                        }
                    }
                }

                // Input area
                inputArea
            }
            .background(SereneColors.background(colorScheme))
            .navigationTitle("Modo difícil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cerrar") { dismiss() }
                        .foregroundColor(SereneColors.textSecondary(colorScheme))
                }
            }
            .onAppear(perform: startConversation)
        }
    }

    private var header: some View {
        HStack(spacing: Spacing.sm) {
            ZStack {
                Circle()
                    .fill(SereneColors.rosaSoft(colorScheme))
                    .frame(width: 28, height: 28)
                Image(systemName: "heart.fill")
                    .font(.system(size: 12))
                    .foregroundColor(SereneColors.rosa(colorScheme))
            }
            Text("Está bien no encontrar nada. Vamos juntos.")
                .sereneMicro()
                .foregroundColor(SereneColors.textSecondary(colorScheme))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Spacing.lg)
        .padding(.vertical, Spacing.sm)
        .background(SereneColors.rosaSoft(colorScheme).opacity(0.3))
    }

    @ViewBuilder
    private func messageBubble(_ message: DifficultModeMessage) -> some View {
        HStack(alignment: .top) {
            if message.role == .coach {
                HStack(alignment: .top, spacing: Spacing.sm) {
                    ZStack {
                        Circle()
                            .fill(SereneColors.sage(colorScheme))
                            .frame(width: 24, height: 24)
                        Image(systemName: "sparkle")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Text(message.content)
                        .sereneBody()
                        .foregroundColor(SereneColors.textPrimary(colorScheme))
                        .padding(Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: Radius.md)
                                .fill(SereneColors.surface(colorScheme))
                        )
                }
                Spacer(minLength: Spacing.xl)
            } else {
                Spacer(minLength: Spacing.xl)
                Text(message.content)
                    .sereneBody()
                    .foregroundColor(.white)
                    .padding(Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: Radius.md)
                            .fill(SereneColors.sage(colorScheme))
                    )
            }
        }
    }

    private func suggestionCard(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "sparkles")
                    .foregroundColor(SereneColors.arena(colorScheme))
                Text("Posible gratitud")
                    .sereneLabel()
                    .foregroundColor(SereneColors.arena(colorScheme))
            }
            Text(text)
                .sereneBody()
                .foregroundColor(SereneColors.textPrimary(colorScheme))

            HStack(spacing: Spacing.sm) {
                Button {
                    onGratitudeCrystallized(text)
                    dismiss()
                } label: {
                    Text("Guardar así")
                        .sereneBody(14)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: Radius.md)
                                .fill(SereneColors.sage(colorScheme))
                        )
                }
                Button {
                    suggestedGratitude = nil
                    isInputFocused = true
                } label: {
                    Text("Seguir")
                        .sereneBody(14)
                        .foregroundColor(SereneColors.sage(colorScheme))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: Radius.md)
                                .stroke(SereneColors.sage(colorScheme), lineWidth: 1)
                        )
                }
            }
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Radius.lg)
                .fill(SereneColors.arenaSoft(colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.lg)
                        .stroke(SereneColors.arena(colorScheme).opacity(0.4), lineWidth: 1)
                )
        )
    }

    private var inputArea: some View {
        HStack(alignment: .bottom, spacing: Spacing.sm) {
            TextField("Escribe lo que sea...", text: $currentInput, axis: .vertical)
                .sereneBody()
                .foregroundColor(SereneColors.textPrimary(colorScheme))
                .lineLimit(1...4)
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: Radius.lg)
                        .fill(SereneColors.surface(colorScheme))
                        .overlay(
                            RoundedRectangle(cornerRadius: Radius.lg)
                                .stroke(
                                    isInputFocused ? SereneColors.sage(colorScheme) : SereneColors.borderDefault(colorScheme),
                                    lineWidth: BorderWidth.default
                                )
                        )
                )
                .focused($isInputFocused)

            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(canSend ? SereneColors.sage(colorScheme) : SereneColors.borderDefault(colorScheme))
                    )
            }
            .disabled(!canSend)
        }
        .padding(Spacing.md)
        .background(SereneColors.background(colorScheme))
    }

    private var canSend: Bool {
        !currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isTyping
    }

    // MARK: - Conversation flow
    private func startConversation() {
        let opener = DifficultModeService.shared.openingMessage(userName: appState.userName)
        messages.append(DifficultModeMessage(role: .coach, content: opener, timestamp: Date()))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            isInputFocused = true
        }
    }

    private func sendMessage() {
        let trimmed = currentInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let userMessage = DifficultModeMessage(role: .user, content: trimmed, timestamp: Date())
        messages.append(userMessage)
        currentInput = ""
        isTyping = true

        Task {
            // Simulate small thinking delay for natural feel
            try? await Task.sleep(nanoseconds: 600_000_000)

            let response = await DifficultModeService.shared.getResponse(
                userName: appState.userName,
                history: messages,
                userMessage: trimmed
            )

            await MainActor.run {
                isTyping = false
                messages.append(DifficultModeMessage(
                    role: .coach,
                    content: response.response,
                    timestamp: Date()
                ))
                if let suggestion = response.suggestedGratitude {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation(.easeOut(duration: 0.4)) {
                            suggestedGratitude = suggestion
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DifficultModeView { _ in }
        .environmentObject(AppState())
}
