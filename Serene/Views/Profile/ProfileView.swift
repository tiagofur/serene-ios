import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationStack {
            List {
                // Stats section
                Section {
                    HStack {
                        statItem(value: "\(appState.currentStreak)", label: "Racha actual")
                        Divider()
                        statItem(value: "\(appState.todayGratitudes.count)", label: "Hoy")
                        Divider()
                        statItem(value: "0", label: "Total")
                    }
                    .padding(.vertical, Spacing.sm)
                }
                .listRowBackground(Color.surface)

                // Subscription section
                Section("Suscripcion") {
                    HStack {
                        Image(systemName: "leaf.fill")
                            .foregroundStyle(Color.sage)
                        Text("Plan Free")
                            .font(.body)
                            .foregroundStyle(Color.textPrimary)
                        Spacer()
                        Button("Mejorar") {}
                            .font(.label)
                            .foregroundStyle(Color.sage)
                    }
                }
                .listRowBackground(Color.surface)

                // Settings section
                Section("Ajustes") {
                    NavigationLink {
                        Text("Recordatorio")
                    } label: {
                        Label("Recordatorio diario", systemImage: "bell")
                    }

                    NavigationLink {
                        Text("Idioma")
                    } label: {
                        Label("Idioma", systemImage: "globe")
                    }

                    NavigationLink {
                        Text("Apariencia")
                    } label: {
                        Label("Apariencia", systemImage: "paintbrush")
                    }
                }
                .listRowBackground(Color.surface)

                // About section
                Section("Acerca de") {
                    NavigationLink {
                        Text("Privacidad")
                    } label: {
                        Label("Politica de privacidad", systemImage: "lock.shield")
                    }

                    NavigationLink {
                        Text("Terminos")
                    } label: {
                        Label("Terminos de uso", systemImage: "doc.text")
                    }

                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .font(.label)
                            .foregroundStyle(Color.textTertiary)
                    }
                }
                .listRowBackground(Color.surface)
            }
            .scrollContentBackground(.hidden)
            .background(Color.backgroundPrimary)
            .navigationTitle("Perfil")
        }
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: Spacing.xs) {
            Text(value)
                .font(.jakarta(20, weight: .bold))
                .foregroundStyle(Color.sage)
            Text(label)
                .font(.micro)
                .foregroundStyle(Color.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}
