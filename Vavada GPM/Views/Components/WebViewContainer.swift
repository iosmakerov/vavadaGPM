import SwiftUI
import WebKit

struct WebViewContainer: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    @Binding var pageTitle: String
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewContainer
        
        init(_ parent: WebViewContainer) {
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
                self.parent.pageTitle = "Ошибка загрузки"
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
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        
        // Настройки для поддержки казино и игровых операторов
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.allowsAirPlayForMediaPlayback = true
        
        // Настройки для улучшенной совместимости
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preferences
        
        // Настройки пользовательского агента
        configuration.applicationNameForUserAgent = "Version/15.0 Mobile/15E148 Safari/604.1"
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        
        // Дополнительные настройки для лучшей совместимости
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.bounces = true
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        
        // Устанавливаем кастомный User-Agent для лучшей совместимости с казино
        webView.customUserAgent = CloakingConstants.userAgent
        
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

#Preview {
    WebViewContainer(
        url: URL(string: "https://www.apple.com")!,
        isLoading: .constant(true),
        pageTitle: .constant("Apple"),
        canGoBack: .constant(false),
        canGoForward: .constant(false)
    )
} 