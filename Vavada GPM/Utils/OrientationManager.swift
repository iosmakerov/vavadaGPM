import UIKit

/// Менеджер для управления ориентацией экрана для iOS 16.6+
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
        
        // ПРИНУДИТЕЛЬНО разрешаем все ориентации через windowScene
        forceUpdateSupportedOrientations(orientations)
    }
    
    /// Заблокировать только портретную ориентацию
    func lockToPortrait() {
        print("🔄 [OrientationManager] Locking to portrait")
        setSupportedOrientations(.portrait)
        
        // ПРИНУДИТЕЛЬНО блокируем портретную ориентацию
        forceUpdateSupportedOrientations(.portrait)
        
        // Принудительно поворачиваем в портретную если нужно
        forcePortraitOrientation()
    }
    
    // MARK: - КРИТИЧНЫЕ МЕТОДЫ для iOS 16.6+
    
    /// ПРИНУДИТЕЛЬНО обновляет поддерживаемые ориентации через windowScene (iOS 16+)
    private func forceUpdateSupportedOrientations(_ orientations: UIInterfaceOrientationMask) {
        print("🔄 [OrientationManager] FORCE updating supported orientations: \(orientations)")
        
        DispatchQueue.main.async {
            // Получаем активную windowScene
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) else {
                print("❌ [OrientationManager] No active windowScene found")
                return
            }
            
            print("🔄 [OrientationManager] Found active windowScene: \(windowScene)")
            
            // Обновляем поддерживаемые ориентации через geometryRequest
            let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: orientations)
            windowScene.requestGeometryUpdate(geometryPreferences) { error in
                if error != nil {
                    print("❌ [OrientationManager] Error updating geometry: \(error)")
                } else {
                    print("✅ [OrientationManager] Successfully updated supported orientations")
                }
            }
            
            // Дополнительное уведомление системе
            NotificationCenter.default.post(name: UIDevice.orientationDidChangeNotification, object: nil)
        }
    }
    
    /// ПРИНУДИТЕЛЬНО поворачивает устройство в портретную ориентацию
    private func forcePortraitOrientation() {
        print("🔄 [OrientationManager] FORCE rotating to portrait")
        
        DispatchQueue.main.async {
            // Получаем активную windowScene
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) else {
                print("❌ [OrientationManager] No active windowScene for rotation")
                return
            }
            
            // Принудительно поворачиваем в портретную
            let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(
                interfaceOrientations: .portrait
            )
            
            windowScene.requestGeometryUpdate(geometryPreferences) { error in
                if error != nil {
                    print("❌ [OrientationManager] Error forcing portrait: \(error)")
                } else {
                    print("✅ [OrientationManager] Successfully forced portrait orientation")
                }
            }
        }
    }
    
    /// Дополнительный метод для отладки текущей ориентации
    func logCurrentState() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) {
                
                print("📱 [OrientationManager] Current interface orientation: \(windowScene.interfaceOrientation.rawValue)")
                print("📱 [OrientationManager] Supported orientations: \(self.currentOrientation.rawValue)")
            }
        }
    }
} 