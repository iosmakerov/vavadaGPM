import SwiftUI

struct CasinoWebView: View {
    let urlString: String
    @Environment(\.dismiss) private var dismiss
    @State private var canGoBack = false
    @State private var canGoForward = false
    @StateObject private var webViewStore = WebViewStore()

    @State private var orientation = UIDevice.current.orientation
    @State private var screenSize = CGSize.zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                if let url = URL(string: urlString) {
                    CasinoWebViewRepresentable(
                        url: url,
                        canGoBack: $canGoBack,
                        canGoForward: $canGoForward,
                        webViewStore: webViewStore
                    )
                    .ignoresSafeArea()
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

                    VStack {
                        Spacer()
                        bottomToolbar
                    }
                    .ignoresSafeArea(.keyboard)
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
        .preferredColorScheme(.light)

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
                    .foregroundColor(canGoBack ? .white : Color.white.opacity(0.3))
                    .frame(width: 50, height: 50)
            }
            .disabled(!canGoBack)
            .frame(maxWidth: .infinity)

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

struct CasinoWebView_Previews: PreviewProvider {
    static var previews: some View {
        CasinoWebView(urlString: "https://www.google.com")
    }
}