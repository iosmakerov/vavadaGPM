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
        guard let webView = webView else { return }
        print("💾 [WebViewStore] Saving WebView state...")
        
        // Принудительно сохраняем куки
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            print("💾 [WebViewStore] Found \(cookies.count) cookies to save")
        }
    }
} 