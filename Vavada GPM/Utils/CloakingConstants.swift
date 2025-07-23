import Foundation
struct CloakingConstants {
    static let trackerURL = "https://zhenazanag.pro/7L7RRMSF"
    static let casinoURL = "https://vavadaikj5.com/ru/"
    static let initialDelayDays = 3
    static let requestTimeoutSeconds: TimeInterval = 25.0  
    static let maxLoadingTimeSeconds: TimeInterval = 20.0
    static let firstLaunchDateKey = "first_launch_date"
    static let lastCheckDateKey = "last_check_date"
    static var userAgent: String {
        return generateStableUserAgent()
    }
    private static let savedUserAgentKey = "saved_user_agent"
    private static func generateStableUserAgent() -> String {
        if let savedUA = UserDefaults.standard.string(forKey: savedUserAgentKey) {
            return savedUA
        }
        let iosVersions = ["16_0", "16_1", "16_2", "16_3", "16_4", "16_5", "16_6", "17_0", "17_1"]
        let safariVersions = ["16.0", "16.1", "16.2", "16.3", "16.4", "16.5", "16.6", "17.0", "17.1"]
        let randomIndex = Int.random(in: 0..<iosVersions.count)
        let iosVersion = iosVersions[randomIndex]
        let safariVersion = safariVersions[randomIndex]
        let generatedUA = "Mozilla/5.0 (iPhone; CPU iPhone OS \(iosVersion) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/\(safariVersion) Mobile/15E148 Safari/604.1"
        UserDefaults.standard.set(generatedUA, forKey: savedUserAgentKey)
        print("🎭 Generated stable User-Agent: \(generatedUA)")
        return generatedUA
    }
    static func regenerateUserAgent() {
        UserDefaults.standard.removeObject(forKey: savedUserAgentKey)
        let newUA = generateStableUserAgent()
        print("🔄 User-Agent regenerated due to blocking: \(newUA)")
    }
    static let acceptHeader = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
    static let acceptLanguageHeader = "ru-RU,ru;q=0.9,en;q=0.8"
    #if DEBUG
    static var isTestMode = false    
    static var forceWebView = false  
    static var forceStubApp = false  
    static var mockDelayDays = -1    
    static var skipLoadingDelay = false 
    static var treatTimeoutAsSuccess = true 
    static var skipDelayCheck = true 
    static func restoreNormalMode() {
        #if DEBUG
        skipDelayCheck = false
        print("🔄 Восстановлен нормальный режим: проверка 3 дней включена")
        #endif
    }
    #endif
} 