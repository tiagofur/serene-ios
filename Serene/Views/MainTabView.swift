import SwiftUI

struct MainTabView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem {
                    Label("Hoy", systemImage: "leaf")
                }
                .tag(0)

            HistoryView()
                .tabItem {
                    Label("Historial", systemImage: "book")
                }
                .tag(1)

            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "sparkles")
                }
                .tag(2)

            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.circle")
                }
                .tag(3)
        }
        .tint(SereneColors.sage(colorScheme))
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}
