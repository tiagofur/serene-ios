import SwiftUI

struct GratitudeWriteSheet: View {
    let slot: GratitudeSlot
    @ObservedObject var viewModel: TodayViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var text = ""
    @State private var selectedEmoji: GratitudeEmoji = .neutral
    @State private var isSaving = false
    @State private var coachResponse: String?
    @State private var displayedResponse = ""

    private var prompt: String {
        Gratitude.prompt(for: slot.index, isExtra: slot.isExtra)
    }

    private var slotLabel: String {
        let number = slot.isExtra ? slot.index + 4 : slot.index + 1
        let total = slot.isExtra ? Gratitude.totalSlotCount : Gratitude.baseSlotCount
        return "Gratitud \(number) de \(total)"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    // Emoji selector
                    emojiSelector

                    // Text field
                    textEditor

                    // Coach response
                    if isSaving {
                        TypingIndicator()
                    } else if !displayedResponse.isEmpty {
                        CoachReplyBubble(text: displayedResponse)
                    }
                }
                .padding(Spacing.md)
            }
            .background(Color.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(slotLabel)
                        .font(.label)
                        .foregroundStyle(Color.textSecondary)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.body)
                            .foregroundStyle(Color.textSecondary)
                            .frame(width: 28, height: 28)
                            .background(Color.surface)
                            .clipShape(Circle())
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if coachResponse != nil {
                    Button {
                        dismiss()
                    } label: {
                        Text("Guardar y continuar")
                            .font(.jakarta(14, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(15)
                            .background(Color.sage)
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
                    }
                    .padding(Spacing.md)
                } else if !isSaving {
                    Button {
                        save()
                    } label: {
                        Text("Guardar")
                            .font(.jakarta(14, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(15)
                            .background(text.isEmpty ? Color.sage.opacity(0.5) : Color.sage)
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
                    }
                    .disabled(text.isEmpty)
                    .padding(Spacing.md)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    // MARK: - Emoji Selector

    private var emojiSelector: some View {
        HStack(spacing: Spacing.sm) {
            ForEach(GratitudeEmoji.allCases, id: \.self) { emoji in
                Button {
                    selectedEmoji = emoji
                } label: {
                    Text(emoji.symbol)
                        .font(.title2)
                        .frame(width: 40, height: 40)
                        .background(
                            selectedEmoji == emoji ? Color.sageSoft : Color.clear
                        )
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.md)
                                .stroke(
                                    selectedEmoji == emoji ? Color.sage : Color.clear,
                                    lineWidth: BorderWidth.emphasis
                                )
                        )
                }
            }
        }
    }

    // MARK: - Text Editor

    private var textEditor: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(prompt)
                    .font(.body)
                    .foregroundStyle(Color.textTertiary)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 8)
            }

            TextEditor(text: $text)
                .font(.body)
                .foregroundStyle(Color.textPrimary)
                .scrollContentBackground(.hidden)
                .frame(minHeight: 100)
        }
        .padding(14)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.lg)
                .stroke(Color.borderDefault, lineWidth: BorderWidth.emphasis)
        )
    }

    // MARK: - Save

    private func save() {
        isSaving = true
        viewModel.saveGratitude(
            text: text,
            emoji: selectedEmoji,
            slot: slot
        ) { response in
            isSaving = false
            coachResponse = response
            animateResponse(response)
        }
    }

    private func animateResponse(_ response: String) {
        displayedResponse = ""
        for (i, char) in response.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.028) {
                displayedResponse.append(char)
            }
        }
    }
}
