import SwiftUI

@main
struct Vavada_GPMApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appStateManager = AppStateManager.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if appStateManager.isLoading {
                    // Показываем экран загрузки пока проверяем клоакинг
                    LoadingScreen()
                        .onAppear { print("🔄 [App] Showing LoadingScreen") }
                } else if appStateManager.shouldShowWebView, let urlString = appStateManager.webViewURL {
                    // Показываем WebView
                    CasinoWebView(urlString: urlString)
                        .onAppear { print("🎰 [App] Showing CasinoWebView with URL: \(urlString)") }
                } else {
                    // Показываем белую часть приложения
                    ContentView()
                        .onAppear { print("⚪ [App] Showing ContentView (white part)") }
                }
            }
            .environmentObject(appStateManager)
            .preferredColorScheme(.light)
            .onAppear {
                print("🚀 [App] App launched")
                print("📱 [App] Initial state - isLoading: \(appStateManager.isLoading), shouldShowWebView: \(appStateManager.shouldShowWebView)")
            }
        }
    }
}
