import SwiftUI
import WebKit

/// UIViewRepresentable обертка для WKWebView с настройками для казино
struct CasinoWebViewRepresentable: UIViewRepresentable {
    // Статический процесс пул и dataStore для сохранения сессии между запусками
    static let sharedProcessPool = WKProcessPool()
    static let persistentDataStore = WKWebsiteDataStore.default()
    
    let url: URL
    @Binding var canGoBack: Bool
    @Binding var canGoForward: Bool
    let webViewStore: WebViewStore
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        // Создаем конфигурацию с настройками для казино
        let configuration = createWebViewConfiguration()
        
        // Создаем WebView
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        
        // Настройки для казино
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = true
        
        // Загружаем URL
        let request = URLRequest(url: url)
        webView.load(request)
        
        // Сохраняем ссылку на WebView в координаторе
        context.coordinator.webView = webView
        
        // Сохраняем WebView в store
        webViewStore.webView = webView
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Обновления не требуются
    }
    
    private func createWebViewConfiguration() -> WKWebViewConfiguration {
        print("🔧 [WebView] Creating WebView configuration with persistent storage")
        let configuration = WKWebViewConfiguration()
        
        // КРИТИЧНО: Используем статические объекты для сохранения между запусками
        configuration.websiteDataStore = Self.persistentDataStore
        configuration.processPool = Self.sharedProcessPool
        
        print("🍪 [WebView] Using persistent dataStore: \(Self.persistentDataStore)")
        print("🔄 [WebView] Using shared processPool: \(Self.sharedProcessPool)")
        
        // Включаем JavaScript
        configuration.preferences.javaScriptEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        // Настройки для правильной работы с медиа
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        // Дополнительные настройки для казино
        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        }
        
        // Настройки для лучшей совместимости
        configuration.suppressesIncrementalRendering = false
        configuration.allowsPictureInPictureMediaPlayback = true
        
        // User Agent для совместимости с казино
        configuration.applicationNameForUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
        
        // Включаем поддержку игровых провайдеров
        let contentController = WKUserContentController()
        
        // JavaScript для оптимизации работы с казино
        let script = """
        // Отключаем ограничения на автовоспроизведение
        document.addEventListener('DOMContentLoaded', function() {
            var videos = document.querySelectorAll('video');
            videos.forEach(function(video) {
                video.muted = false;
            });
        });
        
        // Поддержка полноэкранного режима
        document.documentElement.webkitRequestFullscreen = document.documentElement.webkitRequestFullscreen || document.documentElement.requestFullscreen;
        """
        
        let userScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        contentController.addUserScript(userScript)
        configuration.userContentController = contentController
        
        return configuration
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
            
            // Проверяем и логируем состояние куки
            checkCookieStatus(webView)
            
            // Принудительно сохраняем куки после загрузки каждой страницы
            saveCookiesManually(webView)
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
            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    completionHandler()
                })
                rootViewController.present(alert, animated: true)
            } else {
                completionHandler()
            }
        }
        
        func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
            // Обработка JavaScript confirm
            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
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
        
        // MARK: - Helper Methods
        
        private func updateNavigationState(_ webView: WKWebView) {
            parent.canGoBack = webView.canGoBack
            parent.canGoForward = webView.canGoForward
        }
        
        private func checkCookieStatus(_ webView: WKWebView) {
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                DispatchQueue.main.async {
                    print("🍪 [WebView] Current cookies count: \(cookies.count)")
                    for cookie in cookies.prefix(5) {
                        print("🍪 [WebView] Cookie: \(cookie.name) = \(cookie.value.prefix(20))... for domain: \(cookie.domain)")
                    }
                }
            }
        }
        
        private func saveCookiesManually(_ webView: WKWebView) {
            // Принудительно синхронизируем куки с постоянным хранилищем
            let cookieStore = webView.configuration.websiteDataStore.httpCookieStore
            
            // Получаем все куки и убеждаемся что они сохранены
            cookieStore.getAllCookies { cookies in
                print("💾 [WebView] Manually saving \(cookies.count) cookies")
                
                // Принудительно пересохраняем каждую куку
                for cookie in cookies {
                    cookieStore.setCookie(cookie) {
                        // Куки сохранены
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