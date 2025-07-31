import Foundation
class StorageManager {
    static let shared = StorageManager()
    private let userDefaults = UserDefaults.standard
    private init() {}
}