import SwiftUI
import Combine

@MainActor
class AppStateManager: ObservableObject {
    static let shared = AppStateManager()
    
    private init() {
        // Простая инициализация для белой части приложения
        print("✅ [AppStateManager] White part app initialized")
    }
}