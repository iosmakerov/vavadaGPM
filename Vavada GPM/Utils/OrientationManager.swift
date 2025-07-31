import UIKit
class OrientationManager {
    static let shared = OrientationManager()
    private init() {}
    private var currentOrientation: UIInterfaceOrientationMask = .portrait
    func setSupportedOrientations(_ orientations: UIInterfaceOrientationMask) {
        currentOrientation = orientations
        forceSystemOrientationUpdate()
    }
    func supportedOrientations() -> UIInterfaceOrientationMask {
        return currentOrientation
    }
    func unlockAllOrientations() {
        let orientations: UIInterfaceOrientationMask = UIDevice.current.userInterfaceIdiom == .pad ? .all : .allButUpsideDown
        setSupportedOrientations(orientations)
        forceUpdateSupportedOrientations(orientations)
    }
    func lockToPortrait() {
        setSupportedOrientations(.portrait)
        forceUpdateSupportedOrientations(.portrait)
    }
    private func forceUpdateSupportedOrientations(_ orientations: UIInterfaceOrientationMask) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) else {
                return
            }
            let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: orientations)
            windowScene.requestGeometryUpdate(geometryPreferences) { _ in
            }
        }
    }
    private func forceSystemOrientationUpdate() {
        DispatchQueue.main.async {
            UIViewController.attemptRotationToDeviceOrientation()
            NotificationCenter.default.post(
                name: UIApplication.didChangeStatusBarOrientationNotification,
                object: nil
            )
        }
    }
}