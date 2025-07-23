import SwiftUI
import Combine

@MainActor
class AppStateManager: ObservableObject {
    static let shared = AppStateManager()

    @Published var isLoading = true
    @Published var shouldShowWebView = false
    @Published var webViewURL: String?
    @Published var error: Error?

    private init() {
        checkAppState()
    }

    func checkAppState() {
        Task {
            print("🔍 [AppStateManager] Starting app state check...")
            isLoading = true
            error = nil

            do {
                let result = try await CloakingService.shared.checkCloaking()

                switch result {
                case .showWebView(let url):
                    print("✅ [AppStateManager] Should show WebView with URL: \(url)")
                    shouldShowWebView = true
                    webViewURL = url
                case .showWhitePart:
                    print("⚪ [AppStateManager] Should show white part")
                    shouldShowWebView = false
                    webViewURL = nil
                }

            } catch {

                print("❌ [AppStateManager] Error: \(error.localizedDescription)")
                self.error = error
                shouldShowWebView = false
                webViewURL = nil
            }

            isLoading = false
            print("🏁 [AppStateManager] App state check completed. Loading: false")
        }
    }

    func forceShowWhitePart() {
        shouldShowWebView = false
        webViewURL = nil
        isLoading = false
    }

    func forceShowWebView(with url: String) {
        shouldShowWebView = true
        webViewURL = url
        isLoading = false
    }
}