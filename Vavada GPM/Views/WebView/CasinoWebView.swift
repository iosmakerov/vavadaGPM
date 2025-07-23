import SwiftUI

/// Главный View для отображения WebView с тулбаром
struct CasinoWebView: View {
    let urlString: String
    @Environment(\.dismiss) private var dismiss
    @State private var canGoBack = false
    @State private var canGoForward = false
    @StateObject private var webViewStore = WebViewStore()
    
    var body: some View {
        ZStack {
            // WebView
            if let url = URL(string: urlString) {
                CasinoWebViewRepresentable(
                    url: url,
                    canGoBack: $canGoBack,
                    canGoForward: $canGoForward,
                    webViewStore: webViewStore
                )
                .ignoresSafeArea()
                .onAppear {
                    // КРИТИЧНО: Разблокируем все ориентации для WebView
                    print("🔄 [CasinoWebView] WebView appeared - UNLOCKING ALL ORIENTATIONS")
                    OrientationManager.shared.unlockAllOrientations()
                    
                    // Логируем текущее состояние для отладки
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        OrientationManager.shared.logCurrentState()
                    }
                    
                    // Добавляем observer для сохранения при сворачивании приложения
                    NotificationCenter.default.addObserver(
                        forName: UIApplication.willResignActiveNotification,
                        object: nil,
                        queue: .main
                    ) { _ in
                        print("💾 [CasinoWebView] App will resign active - FORCE SAVING COOKIES")
                        GlobalWebViewManager.shared.forceSaveCookies()
                        webViewStore.saveCurrentState()
                    }
                }
                .onDisappear {
                    // КРИТИЧНО: Принудительно сохраняем куки перед закрытием
                    print("💾 [CasinoWebView] WebView disappearing - FORCE SAVING COOKIES")
                    GlobalWebViewManager.shared.forceSaveCookies()
                    webViewStore.saveCurrentState()
                    
                    // Удаляем observer для предотвращения утечек памяти
                    NotificationCenter.default.removeObserver(
                        self,
                        name: UIApplication.willResignActiveNotification,
                        object: nil
                    )
                    
                    // КРИТИЧНО: Возвращаем только портретную ориентацию
                    print("🔄 [CasinoWebView] LOCKING TO PORTRAIT")
                    OrientationManager.shared.lockToPortrait()
                    
                    // Логируем состояние после блокировки
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        OrientationManager.shared.logCurrentState()
                    }
                }
                
                // Нижний тулбар с навигацией
                VStack {
                    Spacer()
                    bottomToolbar
                }
                .ignoresSafeArea(.keyboard)
            } else {
                // Ошибка URL
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    Text("Invalid URL")
                        .font(.title2)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.1))
            }
        }
        .preferredColorScheme(.light) // Фиксируем светлую тему для WebView
    }
    
    // MARK: - Bottom Toolbar
    
    private var bottomToolbar: some View {
        HStack(spacing: 0) {
            // Кнопка назад
            Button(action: {
                webViewStore.goBack()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(canGoBack ? .white : Color.white.opacity(0.3))
                    .frame(width: 50, height: 50)
            }
            .disabled(!canGoBack)
            .frame(maxWidth: .infinity)
            
            // Кнопка вперед
            Button(action: {
                webViewStore.goForward()
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(canGoForward ? .white : Color.white.opacity(0.3))
                    .frame(width: 50, height: 50)
            }
            .disabled(!canGoForward)
            .frame(maxWidth: .infinity)
        }
        .frame(height: 50)
        .background(
            ColorManager.background
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color.white.opacity(0.2)),
                    alignment: .top
                )
        )
    }
}

// MARK: - Preview

struct CasinoWebView_Previews: PreviewProvider {
    static var previews: some View {
        CasinoWebView(urlString: "https://www.google.com")
    }
} 