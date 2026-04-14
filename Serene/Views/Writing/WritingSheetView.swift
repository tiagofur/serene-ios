import SwiftUI

struct WritingSheetView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState

    let slotIndex: Int
    let prompt: String
    let totalSlots: Int
    @Binding var isLoadingCoach: Bool
    @Binding var coachResponse: String

    let onSave: (String, String) -> Void

    @State private var gratitudeText = ""
    @State private var selectedMood: GratitudeMood?
    @State private var showCoachResponse = false
    @State private var displayedResponse = ""
    @State private var isSaved = false
    @State private var showDifficultMode = false
    @FocusState private var isTextFieldFocused: Bool

    private var slotLabel: String {
        if slotIndex < 3 {
            return "Gratitud \(slotIndex + 1) de \(totalSlots)"
        } else {
            return "Extra \(slotIndex - 2)"
        }
    }

    private var canSave: Bool {
        !gratitudeText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ZStack {
            SereneColors.background(colorScheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                header
                    .padding(.top, Spacing.sm)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: Spacing.lg) {
                        // Prompt
                        Text(prompt)
                            .sereneDisplay(22)
                            .foregroundColor(SereneColors.textPrimary(colorScheme))
                            .padding(.top, Spacing.md)

                        // Emoji selector
                        emojiSelector

                        // Text field
                        textField

                        // Photo button (optional)
                        photoButton

                        // Difficult mode trigger (Pro feature)
                        if appState.userTier == .pro && !isSaved {
                            difficultModeButton
                        }

                        // Coach response area
                        if isLoadingCoach {
                            TypingDotsView()
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }

                        if showCoachResponse && !displayedResponse.isEmpty {
                            CoachReplyView(text: displayedResponse)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }

                        Spacer(minLength: Spacing.xl)
                    }
                    .padding(.horizontal, Spacing.lg)
                }

                // Save button
                if !isSaved {
                    saveButton
                        .padding(.horizontal, Spacing.lg)
                        .padding(.bottom, Spacing.md)
                } else {
                    continueButton
                        .padding(.horizontal, Spacing.lg)
                        .padding(.bottom, Spacing.md)
                }
            }
        }
        .sheet(isPresented: $showDifficultMode) {
            DifficultModeView { crystallizedGratitude in
                gratitudeText = crystallizedGratitude
                isTextFieldFocused = true
            }
            .environmentObject(appState)
        }
        .onChange(of: coachResponse) { _, newValue in
            if !newValue.isEmpty && isSaved {
                animateCoachResponse(newValue)
            }
        }
        .onChange(of: isLoadingCoach) { _, isLoading in
            if !isLoading && !coachResponse.isEmpty && isSaved {
                animateCoachResponse(coachResponse)
            }
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack {
            Text(slotLabel)
                .sereneLabel()
                .foregroundColor(SereneColors.textTertiary(colorScheme))

            Spacer()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(SereneColors.textSecondary(colorScheme))
                    .frame(width: 28, height: 28)
                    .background(
                        Circle()
                            .fill(SereneColors.surface(colorScheme))
                    )
            }
        }
        .padding(.horizontal, Spacing.lg)
    }

    // MARK: - Emoji Selector
    private var emojiSelector: some View {
        HStack(spacing: Spacing.md) {
            ForEach(GratitudeMood.allCases) { mood in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedMood = mood
                    }
                } label: {
                    Text(mood.rawValue)
                        .font(.system(size: 22))
                        .frame(width: 40, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: Radius.md)
                                .fill(selectedMood == mood ?
                                      SereneColors.sageSoft(colorScheme) : Color.clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: Radius.md)
                                .stroke(
                                    selectedMood == mood ?
                                    SereneColors.sage(colorScheme) : SereneColors.borderDefault(colorScheme),
                                    lineWidth: selectedMood == mood ? BorderWidth.emphasis : BorderWidth.default
                                )
                        )
                }
            }
        }
    }

    // MARK: - Text Field
    private var textField: some View {
        TextEditor(text: $gratitudeText)
            .sereneBody()
            .foregroundColor(SereneColors.textPrimary(colorScheme))
            .scrollContentBackground(.hidden)
            .frame(minHeight: 100)
            .padding(.horizontal, 14)
            .padding(.vertical, Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Radius.lg)
                    .fill(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.lg)
                            .stroke(
                                isTextFieldFocused ? SereneColors.sage(colorScheme) : SereneColors.borderDefault(colorScheme),
                                lineWidth: BorderWidth.emphasis
                            )
                    )
            )
            .focused($isTextFieldFocused)
            .onAppear {
                isTextFieldFocused = true
            }
    }

    // MARK: - Photo Button
    private var photoButton: some View {
        Button {
            // Photo picker action
        } label: {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "camera")
                    .font(.system(size: 14))
                Text("Añadir foto")
                    .sereneLabel()
                Text("(opcional)")
                    .sereneMicro()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
            }
            .foregroundColor(SereneColors.textSecondary(colorScheme))
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm + 2)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.sm)
                    .stroke(SereneColors.borderDefault(colorScheme), style: StrokeStyle(lineWidth: 1, dash: [5, 3]))
            )
        }
    }

    // MARK: - Difficult Mode Button (Pro)
    private var difficultModeButton: some View {
        Button {
            showDifficultMode = true
        } label: {
            HStack(spacing: Spacing.sm) {
                Image(systemName: "heart.circle")
                    .font(.system(size: 14))
                Text("No encuentro nada hoy")
                    .sereneLabel()
            }
            .foregroundColor(SereneColors.rosa(colorScheme))
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm + 2)
            .background(
                Capsule()
                    .fill(SereneColors.rosaSoft(colorScheme).opacity(0.5))
            )
        }
    }

    // MARK: - Save Button
    private var saveButton: some View {
        Button {
            guard canSave else { return }
            isSaved = true
            onSave(gratitudeText, selectedMood?.rawValue ?? "")
        } label: {
            Text("Guardar")
                .sereneBody(14)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: Radius.lg)
                        .fill(canSave ? SereneColors.sage(colorScheme) : SereneColors.borderDefault(colorScheme))
                )
        }
        .disabled(!canSave)
    }

    // MARK: - Continue Button
    private var continueButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Guardar y continuar")
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

    // MARK: - Animate Coach Response (character by character)
    private func animateCoachResponse(_ fullText: String) {
        showCoachResponse = true
        displayedResponse = ""
        var charIndex = 0
        Timer.scheduledTimer(withTimeInterval: 0.028, repeats: true) { timer in
            if charIndex < fullText.count {
                let index = fullText.index(fullText.startIndex, offsetBy: charIndex)
                displayedResponse += String(fullText[index])
                charIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

#Preview {
    WritingSheetView(
        slotIndex: 0,
        prompt: "Hoy agradezco...",
        totalSlots: 3,
        isLoadingCoach: .constant(false),
        coachResponse: .constant(""),
        onSave: { _, _ in }
    )
}
