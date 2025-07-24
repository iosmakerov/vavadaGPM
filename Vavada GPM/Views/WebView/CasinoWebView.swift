import SwiftUI

struct CasinoWebView: View {
    let urlString: String
    @Environment(\.dismiss) private var dismiss
    @State private var canGoBack = false
    @State private var canGoForward = false
    @StateObject private var webViewStore = WebViewStore()

    @State private var orientation = UIDevice.current.orientation
    @State private var screenSize = CGSize.zero
    
    // Высота тулбара
    private let toolbarHeight: CGFloat = 50

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Фон для всего экрана, включая safe area сверху
                ColorManager.background
                    .ignoresSafeArea(.all)

                if let url = URL(string: urlString) {
                    VStack(spacing: 0) {
                        CasinoWebViewRepresentable(
                            url: url,
                            canGoBack: $canGoBack,
                            canGoForward: $canGoForward,
                            webViewStore: webViewStore
                        )
                        .ignoresSafeArea(.all, edges: [.leading, .trailing, .top])
                        .onAppear {

                            OrientationManager.shared.unlockAllOrientations()

                            screenSize = geometry.size

                            NotificationCenter.default.addObserver(
                                forName: UIApplication.willResignActiveNotification,
                                object: nil,
                                queue: .main
                            ) { _ in
                                GlobalWebViewManager.shared.forceSaveCookies()
                                webViewStore.saveCurrentState()
                            }
                        }
                        .onDisappear {

                            GlobalWebViewManager.shared.forceSaveCookies()
                            webViewStore.saveCurrentState()

                            NotificationCenter.default.removeObserver(
                                self,
                                name: UIApplication.willResignActiveNotification,
                                object: nil
                            )

                            OrientationManager.shared.lockToPortrait()
                        }
                        .onChange(of: geometry.size) { newSize in

                            if newSize != screenSize {
                                screenSize = newSize
                            }
                        }
                        
                        bottomToolbar
                    }
                    .ignoresSafeArea(.keyboard)
                
                // Перекрытие только области под "челкой" 
                VStack {
                    ColorManager.background
                        .frame(height: geometry.safeAreaInsets.top)
                        .ignoresSafeArea(.all, edges: .top)
                    Spacer()
                }
                
                } else {

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
        }
        .preferredColorScheme(.dark)

        .onAppear {
            OrientationManager.shared.setSupportedOrientations(.allButUpsideDown)
        }
        .onDisappear {
            OrientationManager.shared.setSupportedOrientations(.portrait)
        }

        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            orientation = UIDevice.current.orientation
        }
    }

    private var bottomToolbar: some View {
        HStack(spacing: 0) {

            Button(action: {
                webViewStore.goBack()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(canGoBack ? .blue : ColorManager.inactiveGray)
                    .frame(width: 50, height: 50)
            }
            .disabled(!canGoBack)
            .frame(maxWidth: .infinity)

            Button(action: {
                webViewStore.goForward()
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(canGoForward ? .blue : ColorManager.inactiveGray)
                    .frame(width: 50, height: 50)
            }
            .disabled(!canGoForward)
            .frame(maxWidth: .infinity)
        }
        .frame(height: toolbarHeight)
        .background(ColorManager.background)
        // Растягиваем тулбар до самого низа экрана
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct CasinoWebView_Previews: PreviewProvider {
    static var previews: some View {
        CasinoWebView(urlString: "https://www.google.com")
    }
}