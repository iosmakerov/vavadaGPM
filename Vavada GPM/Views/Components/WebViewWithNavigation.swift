import SwiftUI
import WebKit

struct WebViewWithNavigation: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    @Binding var pageTitle: String
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    let onNavigationReady: (@escaping () -> Void, @escaping () -> Void) -> Void
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewWithNavigation
        weak var webView: WKWebView?
        
        init(_ parent: WebViewWithNavigation) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = true
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
                self.parent.pageTitle = webView.title ?? "Vavada Casino"
                self.parent.canGoBack = webView.canGoBack
                self.parent.canGoForward = webView.canGoForward
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
                self.parent.pageTitle = "Loading Error"
            }
            print("WebView navigation failed: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // Логируем все переходы для отладки
            if let url = navigationAction.request.url {
                print("🌐 WebView navigating to: \(url.absoluteString)")
            }
            
            decisionHandler(.allow)
        }
        
        func setupNavigationCallbacks() {
            guard let webView = webView else { return }
            
            let goBack = { [weak webView] in
                DispatchQueue.main.async {
                    webView?.goBack()
                }
            }
            
            let goForward = { [weak webView] in
                DispatchQueue.main.async {
                    webView?.goForward()
                }
            }
            
            DispatchQueue.main.async {
                self.parent.onNavigationReady(goBack, goForward)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        
        // КРИТИЧНЫЕ настройки для казино-операторов (Play N Go, Novomatic)
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.suppressesIncrementalRendering = false
        
        // JavaScript обязателен для игр
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preferences
        
        // WebSite Data Store для стабильного сохранения cookies/данных казино
        let dataStore = WKWebsiteDataStore.default()
        configuration.websiteDataStore = dataStore
        
        // Настройки пользовательского агента
        configuration.applicationNameForUserAgent = "Version/15.0 Mobile/15E148 Safari/604.1"
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        
        // Оптимизированные настройки для казино-игр
        webView.allowsBackForwardNavigationGestures = false // Отключено - мешает играм
        webView.scrollView.bounces = true
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        
        // Черный фон для казино
        webView.isOpaque = true
        webView.backgroundColor = UIColor.black
        
        // User-Agent для детектирования мобильного Safari
        webView.customUserAgent = CloakingConstants.userAgent
        
        // Настройки безопасности для казино (разрешаем mixed content)
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        webView.configuration.preferences.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        
        // Включаем Web Inspector для отладки (только в DEBUG)
        #if DEBUG
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        #endif
        
        // Сохраняем ссылку на webView и настраиваем навигацию
        context.coordinator.webView = webView
        context.coordinator.setupNavigationCallbacks()
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Загружаем URL только если это новый URL
        if webView.url != url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
} 