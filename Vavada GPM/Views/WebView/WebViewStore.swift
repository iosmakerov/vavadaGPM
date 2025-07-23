import WebKit
import Combine

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

        GlobalWebViewManager.shared.forceSaveCookies()
    }
}