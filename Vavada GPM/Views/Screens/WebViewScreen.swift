import SwiftUI

// AppState теперь в Models/TrackerResponse.swift

struct WebViewScreen: View {
    let url: String
    @Binding var appState: AppState
    
    @State private var isLoading = true
    @State private var pageTitle = "Loading..."
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var webViewNavigationActions: (() -> Void, () -> Void)?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // WebView на весь экран
                if let webURL = URL(string: url) {
                    WebViewWithNavigation(
                        url: webURL,
                        isLoading: $isLoading,
                        pageTitle: $pageTitle,
                        canGoBack: $canGoBack,
                        canGoForward: $canGoForward,
                        onNavigationReady: { goBack, goForward in
                            webViewNavigationActions = (goBack, goForward)
                        }
                    )
                    .background(Color.black)
                    .ignoresSafeArea(.all, edges: .top)
                    
                } else {
                    // Fallback в случае некорректного URL
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "wifi.exclamationmark")
                            .font(.system(size: 50))
                            .foregroundColor(ColorManager.primaryRed)
                        
                        Text("Loading Error")
                            .font(FontManager.title)
                            .foregroundColor(ColorManager.white)
                        
                        Text("Unable to load page")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Close App") {
                            // Закрыть приложение полностью
                            exit(0)
                        }
                        .buttonStyle(CustomButtonStyle())
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                    .padding()
                    .background(ColorManager.background)
                }
                
                // Safari-style нижний toolbar
                VStack {
                    Spacer()
                    
                    SafariBottomToolbar(
                        canGoBack: canGoBack,
                        canGoForward: canGoForward,
                        isLoading: isLoading,
                        onBackTapped: {
                            handleWebBackButton()
                        },
                        onForwardTapped: {
                            handleWebForwardButton()
                        }
                    )
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .interactiveDismissDisabled() // Запрет на swipe-to-dismiss
        .gesture(
            // Блокируем swipe жесты для выхода
            DragGesture()
                .onEnded { _ in
                    // Ничего не делаем - блокируем навигацию
                }
        )
        .onAppear {
            print("🌐 WebViewScreen opened with URL: \(url)")
            setupForWebView()
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK") { }
            Button("Close App") {
                // Закрыть приложение полностью при ошибке
                exit(0)
            }
        } message: {
            Text(errorMessage)
        }
        // Поддержка всех ориентаций
        .supportedOrientations(.all)
    }
    
    // MARK: - Actions
    private func handleWebBackButton() {
        print("📱 WebView: Back button tapped")
        webViewNavigationActions?.0()
    }
    
    private func handleWebForwardButton() {
        print("📱 WebView: Forward button tapped")
        webViewNavigationActions?.1()
    }
    
    // Удалена функция handleExitButton - теперь из WebView нельзя выйти
    
    private func setupForWebView() {
        // Дополнительные настройки для веб-вью
        print("⚙️ WebView: Setup completed")
    }
}

// MARK: - Поддержка поворотов экрана (iOS 15.6 совместимость)
extension View {
    func supportedOrientations(_ orientations: UIInterfaceOrientationMask) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            // Для iOS 15.6 просто логируем изменение ориентации
            // Поворот будет поддерживаться автоматически через настройки проекта
            print("📱 Device orientation changed")
        }
    }
}

// MARK: - Custom Button Style для ошибок
struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(FontManager.button)
            .foregroundColor(ColorManager.white)
            .padding()
            .frame(minWidth: 120)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(ColorManager.buttonGradient)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    WebViewScreen(
        url: "https://www.apple.com",
        appState: .constant(.webView(url: "https://www.apple.com"))
    )
} 