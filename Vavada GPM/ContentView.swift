import SwiftUI
struct ContentView: View {
    @State private var appState: AppState = .loading
    @StateObject private var cloakingService = CloakingService()
    var body: some View {
        Group {
            switch appState {
            case .loading:
                LoadingScreen()
                    .task {
                        await performCloakingCheck()
                    }
            case .webView(let url):
                WebViewScreen(url: url, appState: $appState)
            case .stubApp:
                TabContainerView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState)
        .onAppear {
            GameDataService.shared.recordAppLaunch()
        }
    }
    private func performCloakingCheck() async {
        do {
            #if DEBUG
            if !CloakingConstants.skipLoadingDelay {
                try await Task.sleep(nanoseconds: 1_500_000_000) 
            }
            #else
            try await Task.sleep(nanoseconds: 1_500_000_000) 
            #endif
            let result = await cloakingService.checkAccess()
            await MainActor.run {
                switch result {
                case .showWebView(let url):
                    appState = .webView(url: url)
                case .showStubApp:
                    appState = .stubApp
                }
            }
        } catch {
            print("❌ Ошибка при проверке клоакинга: \(error)")
            await MainActor.run {
                appState = .stubApp
            }
        }
    }
}
#Preview {
    ContentView()
}
