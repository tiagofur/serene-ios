import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .today

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem {
                    Label(Tab.today.title, systemImage: Tab.today.icon)
                }
                .tag(Tab.today)

            HistoryView()
                .tabItem {
                    Label(Tab.history.title, systemImage: Tab.history.icon)
                }
                .tag(Tab.history)

            InsightsView()
                .tabItem {
                    Label(Tab.insights.title, systemImage: Tab.insights.icon)
                }
                .tag(Tab.insights)

            ProfileView()
                .tabItem {
                    Label(Tab.profile.title, systemImage: Tab.profile.icon)
                }
                .tag(Tab.profile)
        }
        .tint(.sage)
    }
}

// MARK: - Tab

extension MainTabView {
    enum Tab: String, CaseIterable {
        case today, history, insights, profile

        var title: String {
            switch self {
            case .today: "Hoy"
            case .history: "Historial"
            case .insights: "Insights"
            case .profile: "Perfil"
            }
        }

        var icon: String {
            switch self {
            case .today: "leaf"
            case .history: "book"
            case .insights: "sparkles"
            case .profile: "person.circle"
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}
