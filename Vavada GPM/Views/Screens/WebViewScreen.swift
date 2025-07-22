import SwiftUI

// AppState теперь в Models/TrackerResponse.swift

struct WebViewScreen: View {
    let url: String
    @Binding var appState: AppState
    
    @State private var isLoading = true
    @State private var pageTitle = "Загрузка..."
    @State private var canGoBack = false
    @State private var canGoForward = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Safari-стиль тулбар
                SafariStyleToolbar(
                    title: isLoading ? "Загрузка..." : pageTitle,
                    isLoading: isLoading
                ) {
                    handleBackButton()
                }
                
                // WebView контейнер
                if let webURL = URL(string: url) {
                    WebViewContainer(
                        url: webURL,
                        isLoading: $isLoading,
                        pageTitle: $pageTitle,
                        canGoBack: $canGoBack,
                        canGoForward: $canGoForward
                    )
                    .background(Color.black)
                } else {
                    // Fallback в случае некорректного URL
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "wifi.exclamationmark")
                            .font(.system(size: 50))
                            .foregroundColor(ColorManager.primaryRed)
                        
                        Text("Ошибка загрузки")
                            .font(FontManager.title)
                            .foregroundColor(ColorManager.white)
                        
                        Text("Не удалось загрузить страницу")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Вернуться") {
                            handleBackButton()
                        }
                        .buttonStyle(CustomButtonStyle())
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                    .padding()
                    .background(ColorManager.background)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            print("🌐 WebViewScreen opened with URL: \(url)")
            setupForWebView()
        }
        .alert("Ошибка", isPresented: $showErrorAlert) {
            Button("OK") { }
            Button("Вернуться") {
                handleBackButton()
            }
        } message: {
            Text(errorMessage)
        }
        // Поддержка всех ориентаций
        .supportedOrientations(.all)
    }
    
    private func handleBackButton() {
        print("📱 WebView: Кнопка 'Назад' нажата")
        appState = .stubApp
    }
    
    private func setupForWebView() {
        // Дополнительные настройки для веб-вью
        print("⚙️ WebView: Настройка завершена")
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