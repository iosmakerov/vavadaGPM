import UIKit

/// Менеджер для управления ориентацией экрана
class OrientationManager {
    static let shared = OrientationManager()
    
    private init() {}
    
    /// Текущая поддерживаемая ориентация
    private var currentOrientation: UIInterfaceOrientationMask = .portrait
    
    /// Установить поддерживаемые ориентации
    func setSupportedOrientations(_ orientations: UIInterfaceOrientationMask) {
        print("🔄 [OrientationManager] Setting orientations: \(orientations)")
        currentOrientation = orientations
    }
    
    /// Получить текущие поддерживаемые ориентации
    func supportedOrientations() -> UIInterfaceOrientationMask {
        return currentOrientation
    }
    
    /// Разблокировать все ориентации (для WebView)
    func unlockAllOrientations() {
        // Для iPhone используем все ориентации кроме перевернутой
        let orientations: UIInterfaceOrientationMask = UIDevice.current.userInterfaceIdiom == .pad ? .all : .allButUpsideDown
        print("🔄 [OrientationManager] Unlocking orientations: \(orientations)")
        setSupportedOrientations(orientations)
    }
    
    /// Заблокировать только портретную ориентацию
    func lockToPortrait() {
        print("🔄 [OrientationManager] Locking to portrait")
        setSupportedOrientations(.portrait)
    }
} 