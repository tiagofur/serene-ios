import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = TodayViewModel()
    @State private var selectedSlot: GratitudeSlot?
    @State private var showCelebration = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                greetingSection
                streakCard
                gratitudeSection
                if appState.extrasUnlocked {
                    extraSection
                }
            }
            .padding(.horizontal, Spacing.md)
            .padding(.top, Spacing.md)
        }
        .background(Color.backgroundPrimary)
        .sheet(item: $selectedSlot) { slot in
            GratitudeWriteSheet(slot: slot, viewModel: viewModel)
        }
        .overlay {
            if showCelebration {
                CelebrationOverlay(
                    streakCount: appState.currentStreak,
                    onDismiss: { showCelebration = false }
                )
            }
        }
        .onChange(of: viewModel.justCompletedBase) { _, completed in
            if completed {
                showCelebration = true
                viewModel.justCompletedBase = false
            }
        }
    }

    // MARK: - Greeting

    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(viewModel.greetingTime)
                .font(.label)
                .foregroundStyle(Color.textTertiary)

            Text(viewModel.greeting(for: appState.userName))
                .font(.display)
                .foregroundStyle(Color.textPrimary)
        }
        .padding(.top, Spacing.sm)
    }

    // MARK: - Streak Card

    private var streakCard: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: "flame.fill")
                .font(.title)
                .foregroundStyle(Color.sage)
                .frame(width: 36, height: 36)
                .background(Color.sageSoft)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.md))

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("\(appState.currentStreak)")
                    .font(.jakarta(20, weight: .bold))
                    .foregroundStyle(Color.sage)
                Text("dias de racha")
                    .font(.labelSmall)
                    .foregroundStyle(Color.textTertiary)
            }

            Spacer()

            StreakDotsView(currentDay: viewModel.currentWeekday, completedDays: viewModel.completedDays)
        }
        .padding(Spacing.md)
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    // MARK: - Gratitude Slots

    private var gratitudeSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("MOMENTOS DE GRATITUD")
                .font(.labelSmall)
                .fontWeight(.semibold)
                .tracking(0.72)
                .foregroundStyle(Color.textTertiary)

            ForEach(0..<Gratitude.baseSlotCount, id: \.self) { index in
                let gratitude = viewModel.gratitude(at: index)
                GratitudeSlotView(
                    index: index,
                    gratitude: gratitude,
                    isExtra: false
                ) {
                    selectedSlot = GratitudeSlot(index: index, isExtra: false)
                }
            }
        }
    }

    // MARK: - Extra Slots

    private var extraSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("EXTRAS DESBLOQUEADOS")
                .font(.labelSmall)
                .fontWeight(.semibold)
                .tracking(0.72)
                .foregroundStyle(Color.textTertiary)

            ForEach(0..<Gratitude.extraSlotCount, id: \.self) { index in
                let gratitude = viewModel.extraGratitude(at: index)
                GratitudeSlotView(
                    index: index,
                    gratitude: gratitude,
                    isExtra: true
                ) {
                    selectedSlot = GratitudeSlot(index: index, isExtra: true)
                }
            }
        }
    }
}

// MARK: - Slot identifier

struct GratitudeSlot: Identifiable {
    let index: Int
    let isExtra: Bool
    var id: String { "\(isExtra ? "extra" : "base")-\(index)" }
}

#Preview {
    TodayView()
        .environmentObject(AppState())
}
