import SwiftUI

@main
struct Vavada_GPMApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appStateManager = AppStateManager.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                if appStateManager.isLoading {

                    LoadingScreen()
                } else if appStateManager.shouldShowWebView, let urlString = appStateManager.webViewURL {

                    CasinoWebView(urlString: urlString)
                        .onAppear {

                            OrientationManager.shared.unlockAllOrientations()
                        }
                        .onDisappear {

                            OrientationManager.shared.lockToPortrait()
                        }
                } else {

                    ContentView()
                        .onAppear {

                            OrientationManager.shared.lockToPortrait()
                        }
                }
            }
            .environmentObject(appStateManager)
            .preferredColorScheme(.light)
        }
    }
}

extension View {

    func supportedInterfaceOrientations(_ orientations: UIInterfaceOrientationMask) -> some View {
        self.onAppear {
            OrientationManager.shared.setSupportedOrientations(orientations)
        }
    }
}
