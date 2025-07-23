import WebKit
import Combine

/// Хранилище для управления WebView
class WebViewStore: ObservableObject {
    @Published var webView: WKWebView?
    
    func goBack() {
        webView?.goBack()
    }
    
    func goForward() {
        webView?.goForward()
    }
    
    func reload() {
        webView?.reload()
    }
    
    func saveCurrentState() {
        print("💾 [WebViewStore] Triggering GLOBAL cookie save...")
        
        // Используем глобальный менеджер для принудительного сохранения куки
        GlobalWebViewManager.shared.forceSaveCookies()
        
        // Дополнительное сохранение через текущий WebView если есть
        if let webView = webView {
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                print("💾 [WebViewStore] Current WebView has \(cookies.count) cookies - they are auto-saved by GlobalWebViewManager")
            }
        }
    }
} 