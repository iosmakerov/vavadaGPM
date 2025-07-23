import SwiftUI
import WebKit
struct WebViewWithNavigation: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    @Binding var pageTitle: String
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    let onNavigationReady: (@escaping () -> Void, @escaping () -> Void) -> Void
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
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
            if let urlError = error as? URLError {
                print("🚫 WebView navigation failed:")
                print("   Code: \(urlError.code.rawValue)")
                print("   Description: \(urlError.localizedDescription)")
                print("   URL: \(urlError.failingURL?.absoluteString ?? "unknown")")
                if urlError.code.rawValue == -999, let failedURL = urlError.failingURL {
                    print("🔄 Request was cancelled - forcing reload for registration/casino pages")
                    print("🎯 Reloading URL: \(failedURL.absoluteString)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let request = URLRequest(url: failedURL)
                        webView.load(request)
                    }
                }
            } else {
                print("WebView navigation failed: \(error.localizedDescription)")
            }
        }
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url {
                print("🌐 WebView navigating to: \(url.absoluteString)")
                print("🔍 Navigation type: \(navigationAction.navigationType.rawValue)")
                print("🎯 Target frame: \(navigationAction.targetFrame?.isMainFrame ?? false ? "main" : "popup/iframe")")
                if url.path.contains("register") || url.absoluteString.contains("register") {
                    print("🎪 REGISTRATION LINK DETECTED - ensuring it loads")
                    decisionHandler(.allow)
                    return
                }
            }
            decisionHandler(.allow)
        }
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if let url = navigationAction.request.url {
                print("🎪 Popup window requested: \(url.absoluteString)")
                webView.load(navigationAction.request)
            }
            return nil 
        }
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            print("🚨 JavaScript Alert: \(message)")
            completionHandler()
        }
        func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
            print("❓ JavaScript Confirm: \(message)")
            completionHandler(true)
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
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.suppressesIncrementalRendering = false
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preferences
        let dataStore = WKWebsiteDataStore.default()
        configuration.websiteDataStore = dataStore
        configuration.applicationNameForUserAgent = "Version/17.0 Mobile/15E148 Safari/604.1"
        configuration.preferences.setValue(true, forKey: "fullScreenEnabled")
        configuration.preferences.setValue(true, forKey: "DOMPasteAllowed")
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator 
        webView.allowsBackForwardNavigationGestures = false 
        webView.scrollView.bounces = true
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        webView.isOpaque = true
        webView.backgroundColor = UIColor.black
        webView.customUserAgent = CloakingConstants.userAgent
        webView.configuration.processPool = WKProcessPool() 
        webView.allowsLinkPreview = false 
        #if DEBUG
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        #endif
        context.coordinator.webView = webView
        context.coordinator.setupNavigationCallbacks()
        return webView
    }
    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url != url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
} 