import Foundation

class StorageManager {
    static let shared = StorageManager()

    private let userDefaults = UserDefaults.standard

    private enum Keys {
        static let firstLaunchDate = "app.firstLaunchDate"
        static let cloakingResult = "app.cloakingResult"
        static let cloakingURL = "app.cloakingURL"
        static let wasNetworkError = "app.wasNetworkError"
    }

    private init() {}

    var firstLaunchDate: Date? {
        get {
            userDefaults.object(forKey: Keys.firstLaunchDate) as? Date
        }
        set {
            userDefaults.set(newValue, forKey: Keys.firstLaunchDate)
        }
    }

    func hasPassedDaysSinceFirstLaunch(_ days: Int) -> Bool {
        guard let firstLaunch = firstLaunchDate else {

            let now = Date()
            print("📅 [StorageManager] No first launch date found, setting to: \(now)")
            firstLaunchDate = now
            return false
        }

        let daysPassed = Calendar.current.dateComponents([.day], from: firstLaunch, to: Date()).day ?? 0
        print("📅 [StorageManager] First launch: \(firstLaunch)")
        print("📅 [StorageManager] Days passed: \(daysPassed) / Required: \(days)")
        return daysPassed >= days
    }

    var cloakingResult: Bool? {
        get {
            guard userDefaults.object(forKey: Keys.cloakingResult) != nil else { return nil }
            return userDefaults.bool(forKey: Keys.cloakingResult)
        }
        set {
            if let value = newValue {
                userDefaults.set(value, forKey: Keys.cloakingResult)
            } else {
                userDefaults.removeObject(forKey: Keys.cloakingResult)
            }
        }
    }

    var cloakingURL: String? {
        get {
            userDefaults.string(forKey: Keys.cloakingURL)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.cloakingURL)
        }
    }

    var wasNetworkError: Bool {
        get {
            userDefaults.bool(forKey: Keys.wasNetworkError)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.wasNetworkError)
        }
    }

    func saveCloakingResult(shouldShowWebView: Bool, url: String?) {
        cloakingResult = shouldShowWebView
        cloakingURL = url
        wasNetworkError = false
    }

    func clearCloakingResult() {
        cloakingResult = nil
        cloakingURL = nil
        wasNetworkError = true
    }
}