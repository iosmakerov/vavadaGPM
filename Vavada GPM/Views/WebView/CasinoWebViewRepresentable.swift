import SwiftUI
import WebKit

/// ГЛОБАЛЬНЫЙ СИНГЛТОН для сохранения WebView и куки между перезапусками
class GlobalWebViewManager: ObservableObject {
    static let shared = GlobalWebViewManager()
    
    private var _webView: WKWebView?
    private let processPool = WKProcessPool()
    
    private init() {}
    
    func getWebView() -> WKWebView {
        if let existingWebView = _webView {
            print("🔄 [GlobalWebViewManager] Reusing existing WebView with saved cookies")
            return existingWebView
        }
        
        print("🔄 [GlobalWebViewManager] Creating new WebView with persistent storage")
        let webView = createPersistentWebView()
        _webView = webView
        return webView
    }
    
    private func createPersistentWebView() -> WKWebView {
        let configuration = WKWebViewConfiguration()
        
        // КРИТИЧНО: Используем один processPool и dataStore для всего приложения
        configuration.processPool = processPool
        configuration.websiteDataStore = WKWebsiteDataStore.default()
        
        // Настройки для казино
        configuration.preferences.javaScriptEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        }
        
        configuration.suppressesIncrementalRendering = false
        configuration.allowsPictureInPictureMediaPlayback = true
        configuration.applicationNameForUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1"
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = true
        
        return webView
    }
    
    func loadURL(_ url: URL) {
        let webView = getWebView()
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func forceSaveCookies() {
        guard let webView = _webView else { return }
        
        // Принудительно сохраняем все куки в HTTPCookieStorage
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            print("💾 [GlobalWebViewManager] Force saving \(cookies.count) cookies to HTTPCookieStorage")
            
            for cookie in cookies {
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
    }
}

/// UIViewRepresentable обертка для глобального WebView
struct CasinoWebViewRepresentable: UIViewRepresentable {
    let url: URL
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    let webViewStore: WebViewStore
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        // Получаем ГЛОБАЛЬНЫЙ WebView
        let webView = GlobalWebViewManager.shared.getWebView()
        
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        
        // Загружаем URL
        GlobalWebViewManager.shared.loadURL(url)
        
        // Сохраняем ссылку на WebView в координаторе
        context.coordinator.webView = webView
        
        // Сохраняем WebView в store
        webViewStore.webView = webView
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Обновления не требуются для глобального WebView
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: CasinoWebViewRepresentable
        weak var webView: WKWebView?
        
        init(_ parent: CasinoWebViewRepresentable) {
            self.parent = parent
        }
        
        // MARK: - WKNavigationDelegate
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            updateNavigationState(webView)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            updateNavigationState(webView)
            
            // Принудительно сохраняем куки после каждой загрузки
            GlobalWebViewManager.shared.forceSaveCookies()
            
            // Логируем состояние куки для отладки
            logCookieStatus(webView)
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            updateNavigationState(webView)
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // Разрешаем все навигации для казино
            decisionHandler(.allow)
        }
        
        // MARK: - WKUIDelegate
        
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            // Открываем ссылки в том же WebView
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
        
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            // Обработка JavaScript alert
            DispatchQueue.main.async {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        completionHandler()
                    })
                    rootViewController.present(alert, animated: true)
                } else {
                    completionHandler()
                }
            }
        }
        
        func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
            // Обработка JavaScript confirm
            DispatchQueue.main.async {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                        completionHandler(false)
                    })
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        completionHandler(true)
                    })
                    rootViewController.present(alert, animated: true)
                } else {
                    completionHandler(false)
                }
            }
        }
        
        // MARK: - Helper Methods
        
        private func updateNavigationState(_ webView: WKWebView) {
            parent.canGoBack = webView.canGoBack
            parent.canGoForward = webView.canGoForward
        }
        
        private func logCookieStatus(_ webView: WKWebView) {
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                DispatchQueue.main.async {
                    print("🍪 [WebView] Current cookies count: \(cookies.count)")
                    for cookie in cookies.prefix(3) {
                        print("🍪 [WebView] Cookie: \(cookie.name) for domain: \(cookie.domain)")
                    }
                }
            }
        }
    }
}

// MARK: - WebView Navigation Extension

extension CasinoWebViewRepresentable.Coordinator {
    func goBack() {
        webView?.goBack()
    }
} 