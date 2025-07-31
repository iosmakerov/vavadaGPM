import SwiftUI
import Combine
@MainActor
class AppStateManager: ObservableObject {
    static let shared = AppStateManager()
    private init() {
        print("✅ [AppStateManager] White part app initialized")
    }
}