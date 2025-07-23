import Foundation

/// Менеджер для работы с локальным хранилищем приложения
class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Keys
    private enum Keys {
        static let firstLaunchDate = "app.firstLaunchDate"
        static let cloakingResult = "app.cloakingResult"
        static let cloakingURL = "app.cloakingURL"
        static let wasNetworkError = "app.wasNetworkError"
    }
    
    // MARK: - Init
    private init() {}
    
    // MARK: - First Launch
    
    /// Дата первого запуска приложения
    var firstLaunchDate: Date? {
        get {
            userDefaults.object(forKey: Keys.firstLaunchDate) as? Date
        }
        set {
            userDefaults.set(newValue, forKey: Keys.firstLaunchDate)
        }
    }
    
    /// Проверка, прошло ли указанное количество дней с первого запуска
    func hasPassedDaysSinceFirstLaunch(_ days: Int) -> Bool {
        guard let firstLaunch = firstLaunchDate else {
            // Если нет даты первого запуска, устанавливаем её
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
    
    // MARK: - Cloaking Result
    
    /// Результат клоакинга (true - показать WebView, false - показать белую часть)
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
    
    /// URL для загрузки в WebView
    var cloakingURL: String? {
        get {
            userDefaults.string(forKey: Keys.cloakingURL)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.cloakingURL)
        }
    }
    
    /// Флаг, указывающий была ли ошибка сети при последнем запросе
    var wasNetworkError: Bool {
        get {
            userDefaults.bool(forKey: Keys.wasNetworkError)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.wasNetworkError)
        }
    }
    
    /// Сохранить результат клоакинга
    func saveCloakingResult(shouldShowWebView: Bool, url: String?) {
        cloakingResult = shouldShowWebView
        cloakingURL = url
        wasNetworkError = false
    }
    
    /// Очистить результат клоакинга (используется при network error)
    func clearCloakingResult() {
        cloakingResult = nil
        cloakingURL = nil
        wasNetworkError = true
    }
} 