import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = TodayViewModel()

    var body: some View {
        ZStack {
            SereneColors.background(colorScheme)
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    greetingSection
                    streakCard
                    gratitudeSection
                    if viewModel.extrasUnlocked {
                        extrasSection
                    }
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.md)
                .padding(.bottom, 100)
            }

            if viewModel.showCelebration {
                CelebrationOverlayView(
                    streakCount: viewModel.streakData?.currentStreak ?? 1,
                    onDismiss: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            viewModel.showCelebration = false
                        }
                    },
                    onOpenExtra: { index in
                        viewModel.showCelebration = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            viewModel.openWritingSheet(for: index + 3)
                        }
                    }
                )
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            if viewModel.showMilestone {
                StreakMilestoneView(milestone: viewModel.activeMilestone) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.showMilestone = false
                    }
                }
                .transition(.opacity)
                .zIndex(10)
            }
        }
        .sheet(isPresented: $viewModel.isWritingSheetPresented) {
            WritingSheetView(
                slotIndex: viewModel.selectedSlotIndex,
                prompt: viewModel.promptForSlot(viewModel.selectedSlotIndex),
                totalSlots: viewModel.selectedSlotIndex < 3 ? 3 : 5,
                isLoadingCoach: $viewModel.isLoadingCoachResponse,
                coachResponse: $viewModel.coachResponseText,
                onSave: { text, emoji in
                    Task {
                        await viewModel.saveGratitude(
                            text: text,
                            emoji: emoji,
                            context: modelContext,
                            userName: appState.userName
                        )
                    }
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $viewModel.showRescueSheet) {
            StreakRescueSheet(
                previousStreak: viewModel.streakData?.currentStreak ?? 0,
                canRescue: viewModel.streakData?.canRescue ?? false,
                onRescue: {
                    viewModel.performRescue(
                        context: modelContext,
                        userName: appState.userName
                    )
                }
            )
            .presentationDetents([.medium])
        }
        .onAppear {
            viewModel.loadTodayData(context: modelContext)
            // Check if we should offer a streak rescue
            if viewModel.shouldOfferRescue() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    viewModel.showRescueSheet = true
                }
            }
        }
    }

    // MARK: - Greeting
    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("\(viewModel.greeting) \(viewModel.greetingEmoji)")
                .sereneSectionHeader()
                .foregroundColor(SereneColors.textTertiary(colorScheme))

            Text(appState.userName.isEmpty ? "¿Cómo estás hoy?" : appState.userName)
                .sereneDisplay(28)
                .foregroundColor(SereneColors.textPrimary(colorScheme))
        }
    }

    // MARK: - Streak Card
    private var streakCard: some View {
        StreakCardView(
            currentStreak: viewModel.streakData?.currentStreak ?? 0,
            weekDots: viewModel.weekDots()
        )
    }

    // MARK: - Gratitude Slots
    private var gratitudeSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("GRATITUDES")
                .sereneSectionHeader()
                .foregroundColor(SereneColors.textTertiary(colorScheme))

            ForEach(0..<3, id: \.self) { index in
                let entry = viewModel.todayGratitudes.first { $0.slotIndex == index }
                GratitudeSlotView(
                    index: index,
                    entry: entry,
                    state: slotState(for: index, entry: entry),
                    onTap: {
                        viewModel.openWritingSheet(for: index)
                    }
                )
            }
        }
    }

    // MARK: - Extra Slots
    private var extrasSection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("EXTRAS DESBLOQUEADOS")
                .sereneSectionHeader()
                .foregroundColor(SereneColors.arena(colorScheme))

            ForEach(3..<5, id: \.self) { index in
                let entry = viewModel.todayGratitudes.first { $0.slotIndex == index }
                GratitudeSlotView(
                    index: index,
                    entry: entry,
                    state: entry?.isCompleted == true ? .done : .extraUnlocked,
                    onTap: {
                        viewModel.openWritingSheet(for: index)
                    }
                )
            }
        }
    }

    private func slotState(for index: Int, entry: GratitudeEntry?) -> GratitudeSlotState {
        if let entry, entry.isCompleted {
            return .done
        }
        let previousCompleted = (0..<index).allSatisfy { i in
            viewModel.todayGratitudes.first { $0.slotIndex == i }?.isCompleted == true
        }
        if previousCompleted {
            return .active
        }
        return .empty
    }
}

#Preview {
    TodayView()
        .environmentObject(AppState())
}
