import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appState: AppState

    @Query(sort: \GratitudeEntry.createdAt) private var allGratitudes: [GratitudeEntry]
    @Query private var streakDataItems: [StreakData]

    @State private var showingSubscription = false
    @State private var reminderTime: Date = Date()
    @State private var notificationsEnabled = true

    private var streak: StreakData? {
        streakDataItems.first
    }

    var body: some View {
        NavigationStack {
            ZStack {
                SereneColors.background(colorScheme)
                    .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: Spacing.lg) {
                        profileHeader
                        statsGrid
                        subscriptionCard
                        settingsSection
                        aboutSection
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Perfil")
        }
    }

    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: Spacing.md) {
            // Avatar
            ZStack {
                Circle()
                    .fill(SereneColors.sageSoft(colorScheme))
                    .frame(width: 72, height: 72)
                Text(String(appState.userName.prefix(1)).uppercased())
                    .sereneDisplay(28)
                    .foregroundColor(SereneColors.sage(colorScheme))
            }

            VStack(spacing: Spacing.xs) {
                Text(appState.userName)
                    .sereneHeading(20)
                    .foregroundColor(SereneColors.textPrimary(colorScheme))

                HStack(spacing: Spacing.xs) {
                    if appState.userTier == .pro {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 12))
                            .foregroundColor(SereneColors.arena(colorScheme))
                        Text("Serene Pro")
                            .sereneLabel()
                            .foregroundColor(SereneColors.arena(colorScheme))
                    } else {
                        Text("Plan gratuito")
                            .sereneLabel()
                            .foregroundColor(SereneColors.textTertiary(colorScheme))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.lg)
    }

    // MARK: - Stats Grid
    private var statsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
        ], spacing: Spacing.md) {
            statCard(
                value: "\(allGratitudes.count)",
                label: "Gratitudes",
                icon: "leaf.fill"
            )
            statCard(
                value: "\(streak?.currentStreak ?? 0)",
                label: "Racha actual",
                icon: "flame.fill"
            )
            statCard(
                value: "\(streak?.longestStreak ?? 0)",
                label: "Mejor racha",
                icon: "trophy.fill"
            )
        }
    }

    private func statCard(value: String, label: String, icon: String) -> some View {
        VStack(spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(SereneColors.sage(colorScheme))

            Text(value)
                .sereneHeading(20)
                .foregroundColor(SereneColors.textPrimary(colorScheme))

            Text(label)
                .sereneMicro()
                .foregroundColor(SereneColors.textTertiary(colorScheme))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Radius.md)
                .fill(SereneColors.surface(colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .stroke(SereneColors.borderDefault(colorScheme), lineWidth: BorderWidth.default)
                )
        )
    }

    // MARK: - Subscription
    private var subscriptionCard: some View {
        Group {
            if appState.userTier == .pro {
                proActiveCard
            } else {
                proUpgradeCard
            }
        }
    }

    private var proActiveCard: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundColor(SereneColors.arena(colorScheme))
                Text("Serene Pro activo")
                    .sereneHeading(16)
                    .foregroundColor(SereneColors.textPrimary(colorScheme))
                Spacer()
            }
            Text("Tienes acceso a todas las funciones premium")
                .sereneBody(13)
                .foregroundColor(SereneColors.textSecondary(colorScheme))

            Button {
                // Manage subscription
            } label: {
                Text("Gestionar suscripción")
                    .sereneLabel()
                    .foregroundColor(SereneColors.sage(colorScheme))
            }
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Radius.md)
                .fill(SereneColors.arenaSoft(colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .stroke(SereneColors.arena(colorScheme).opacity(0.3), lineWidth: 1)
                )
        )
    }

    private var proUpgradeCard: some View {
        VStack(spacing: Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Desbloquea Serene Pro")
                        .sereneHeading(16)
                        .foregroundColor(SereneColors.textPrimary(colorScheme))
                    Text("Resúmenes semanales, patrones, historial completo")
                        .sereneMicro()
                        .foregroundColor(SereneColors.textSecondary(colorScheme))
                }
                Spacer()
            }

            Button {
                showingSubscription = true
            } label: {
                Text("Probar 14 días gratis")
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
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Radius.md)
                .fill(SereneColors.surface(colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.md)
                        .stroke(SereneColors.borderDefault(colorScheme), lineWidth: BorderWidth.default)
                )
        )
    }

    // MARK: - Settings
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("AJUSTES")
                .sereneSectionHeader()
                .foregroundColor(SereneColors.textTertiary(colorScheme))

            VStack(spacing: 0) {
                settingRow(icon: "bell.badge", title: "Recordatorio diario") {
                    DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .onChange(of: reminderTime) { _, newTime in
                            appState.updateReminderTime(newTime)
                            NotificationService.shared.scheduleDailyReminder(
                                at: newTime,
                                userName: appState.userName
                            )
                        }
                }

                Divider()
                    .padding(.leading, 52)

                settingRow(icon: "globe", title: "Idioma") {
                    Text("Español")
                        .sereneLabel()
                        .foregroundColor(SereneColors.textTertiary(colorScheme))
                }

                Divider()
                    .padding(.leading, 52)

                settingRow(icon: "moon.fill", title: "Apariencia") {
                    Text("Sistema")
                        .sereneLabel()
                        .foregroundColor(SereneColors.textTertiary(colorScheme))
                }
            }
            .padding(Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Radius.md)
                    .fill(SereneColors.surface(colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.md)
                            .stroke(SereneColors.borderDefault(colorScheme), lineWidth: BorderWidth.default)
                    )
            )
        }
    }

    private func settingRow<Content: View>(icon: String, title: String, @ViewBuilder trailing: () -> Content) -> some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(SereneColors.sage(colorScheme))
                .frame(width: 28)

            Text(title)
                .sereneBody()
                .foregroundColor(SereneColors.textPrimary(colorScheme))

            Spacer()

            trailing()
        }
        .padding(.vertical, Spacing.sm)
    }

    // MARK: - About
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("ACERCA DE")
                .sereneSectionHeader()
                .foregroundColor(SereneColors.textTertiary(colorScheme))

            VStack(spacing: 0) {
                aboutRow("Versión", value: "1.0.0")
                Divider().padding(.leading, Spacing.md)
                aboutRow("Política de privacidad", showChevron: true)
                Divider().padding(.leading, Spacing.md)
                aboutRow("Términos de uso", showChevron: true)
                Divider().padding(.leading, Spacing.md)
                aboutRow("Enviar comentarios", showChevron: true)
            }
            .padding(Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Radius.md)
                    .fill(SereneColors.surface(colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: Radius.md)
                            .stroke(SereneColors.borderDefault(colorScheme), lineWidth: BorderWidth.default)
                    )
            )
        }
    }

    private func aboutRow(_ title: String, value: String? = nil, showChevron: Bool = false) -> some View {
        HStack {
            Text(title)
                .sereneBody()
                .foregroundColor(SereneColors.textPrimary(colorScheme))
            Spacer()
            if let value {
                Text(value)
                    .sereneLabel()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
            }
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
            }
        }
        .padding(.vertical, Spacing.sm)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}
