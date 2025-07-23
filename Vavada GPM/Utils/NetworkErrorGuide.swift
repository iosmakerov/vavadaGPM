import Foundation

// MARK: - 📚 РУКОВОДСТВО ПО СЕТЕВЫМ ОШИБКАМ КЛОАКИНГА

/*
 
 🚨 ЧАСТО ВСТРЕЧАЮЩИЕСЯ ОШИБКИ И ИХ РЕШЕНИЯ:
 
 1. ❌ TIMEOUT ОШИБКА (-1001):
    └── 💭 "The request timed out"
    └── 🔍 ПРИЧИНА: Трекер работает медленно, но доступен (видим редирект)
    └── 🎯 РЕШЕНИЕ: Показываем WebView (трекер частично работает)
    └── ⚙️ НАСТРОЙКА: CloakingConstants.treatTimeoutAsSuccess = true
 
 2. ❌ NO INTERNET (-1009):
    └── 💭 "The Internet connection appears to be offline"
    └── 🔍 ПРИЧИНА: Устройство не подключено к интернету
    └── 🎯 РЕШЕНИЕ: Показываем заглушку
    └── ⚙️ НАСТРОЙКА: Автоматическая обработка
 
 3. ❌ HOST NOT FOUND (-1003):
    └── 💭 "A server with the specified hostname could not be found"
    └── 🔍 ПРИЧИНА: DNS проблемы или трекер недоступен
    └── 🎯 РЕШЕНИЕ: Показываем заглушку
    └── ⚙️ НАСТРОЙКА: Автоматическая обработка
 
 4. ⚠️ IOS SIMULATOR ОШИБКИ:
    └── 💭 "load_eligibility_plist: Failed to open"
    └── 🔍 ПРИЧИНА: Системная ошибка iOS Simulator
    └── 🎯 РЕШЕНИЕ: Игнорировать (не влияет на работу)
    └── ⚙️ НАСТРОЙКА: Не требуется
 
 5. ⚠️ NETWORK CONNECTION WARNINGS:
    └── 💭 "nw_connection_copy_connected_local_endpoint_block_invoke"
    └── 🔍 ПРИЧИНА: Особенности сетевой настройки Simulator
    └── 🎯 РЕШЕНИЕ: Игнорировать (не влияет на работу)
    └── ⚙️ НАСТРОЙКА: Не требуется
 
 
 🧪 DEBUG НАСТРОЙКИ ДЛЯ ТЕСТИРОВАНИЯ:
 
 - forceWebView = true   → Всегда показывать WebView (быстрое тестирование)
 - forceStubApp = true   → Всегда показывать заглушку (тестирование белой части)
 - mockDelayDays = 4     → Имитировать прошедшие дни (> 3 = задержка пройдена)
 - treatTimeoutAsSuccess → При timeout показывать WebView вместо заглушки
 
 
 🚀 ПРОДАКШН НАСТРОЙКИ:
 
 - forceWebView = false
 - forceStubApp = false  
 - mockDelayDays = -1    → Отключить мок, использовать реальные дни
 - treatTimeoutAsSuccess → НЕ ВЛИЯЕТ (только в DEBUG)
 
 
 📋 ЛОГИКА ПРИНЯТИЯ РЕШЕНИЯ:
 
 1. Проверяем временную задержку (3 дня)
 2. Проверяем интернет-соединение
 3. Делаем запрос к трекеру с retry (2 попытки)
 4. Анализируем ответ:
    ├── HTTP 200/401/301/302/307/308 → WebView
    ├── HTTP 404/403 → Заглушка  
    ├── Timeout → WebView (трекер частично работает)
    └── Другие ошибки → Заглушка
 
 */

// MARK: - 🔧 Утилиты для отладки

struct NetworkErrorDebugger {
    
    static func printNetworkDiagnostics() {
        print("🔧 ===== NETWORK DIAGNOSTICS =====")
        
        #if DEBUG
        print("📱 Environment: DEBUG")
        print("🎛️ Debug Settings:")
        print("   forceWebView: \(CloakingConstants.forceWebView)")
        print("   forceStubApp: \(CloakingConstants.forceStubApp)")
        print("   mockDelayDays: \(CloakingConstants.mockDelayDays)")
        print("   treatTimeoutAsSuccess: \(CloakingConstants.treatTimeoutAsSuccess)")
        #else
        print("📱 Environment: PRODUCTION")
        print("🎛️ Using real cloaking logic")
        #endif
        
        print("🌍 Tracker URL: \(CloakingConstants.trackerURL)")
        print("⏱️ Timeout: \(CloakingConstants.requestTimeoutSeconds)s")
        print("🔚 ===== END DIAGNOSTICS =====")
    }
    
    static func recommendationForError(_ error: Error) -> String {
        guard let urlError = error as? URLError else {
            return "Unknown error type - show stub app"
        }
        
        switch urlError.code {
        case .timedOut:
            return "TIMEOUT: Show WebView (tracker partially works)"
        case .notConnectedToInternet, .networkConnectionLost:
            return "NO INTERNET: Show stub app"
        case .cannotFindHost, .cannotConnectToHost:
            return "HOST ISSUES: Show stub app"
        default:
            return "OTHER ERROR: Show stub app"
        }
    }
} 