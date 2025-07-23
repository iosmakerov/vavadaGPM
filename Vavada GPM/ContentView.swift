import SwiftUI

enum AppState {
    case loading
    case stubApp
}

struct ContentView: View {
    @State private var appState: AppState = .loading

    var body: some View {
        Group {
            switch appState {
            case .loading:
                LoadingScreen()
                    .task {
                        await showGameApp()
                    }
            case .stubApp:
                TabContainerView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState)
        .onAppear {
            GameDataService.shared.recordAppLaunch()
        }
    }

    private func showGameApp() async {
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        await MainActor.run {
            appState = .stubApp
        }
    }
}
#Preview {
    ContentView()
}
