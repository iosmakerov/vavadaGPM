import SwiftUI

@main
struct Vavada_GPMApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    OrientationManager.shared.lockToPortrait()
                }
                .preferredColorScheme(.dark)
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
