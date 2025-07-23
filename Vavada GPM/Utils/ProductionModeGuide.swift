import Foundation
struct ProductionModeSettings {
    static func getCurrentSettings() -> String {
        var settings = """
        🚀 БОЕВОЙ РЕЖИМ АКТИВЕН
        📱 Основные настройки:
        ├── Задержка: \(CloakingConstants.initialDelayDays) дня
        ├── Timeout: \(CloakingConstants.requestTimeoutSeconds) сек
        ├── Retry: 2 попытки с паузой 2 сек
        └── Трекер: \(CloakingConstants.trackerURL)
        """
        #if DEBUG
        settings += """
        🧪 Debug настройки:
        ├── forceWebView: \(CloakingConstants.forceWebView) ❌
        ├── forceStubApp: \(CloakingConstants.forceStubApp) ❌  
        ├── mockDelayDays: \(CloakingConstants.mockDelayDays) ❌
        ├── skipLoadingDelay: \(CloakingConstants.skipLoadingDelay) ❌
        ├── treatTimeoutAsSuccess: \(CloakingConstants.treatTimeoutAsSuccess) ✅
        └── skipDelayCheck: \(CloakingConstants.skipDelayCheck) 🧪 ВРЕМЕННО!
        """
        #else
        settings += "🚀 Production Build - все debug настройки недоступны\n\n"
        #endif
        settings += """
        ✅ УЛУЧШЕНИЯ ВКЛЮЧЕНЫ:
        ├── Retry механизм (2 попытки)
        ├── Увеличенный timeout (15 сек) 
        ├── Умная обработка timeout
        ├── Подробное логгирование
        └── Thread-safe сеть проверка
        """
        #if DEBUG
        if CloakingConstants.skipDelayCheck {
            settings += """
        🧪 ТЕСТОВЫЙ РЕЖИМ (skipDelayCheck = true):
        ├── ⚠️ ПРОПУСКАЕТСЯ проверка 3 дней
        ├── Сразу проверяется трекер при каждом запуске
        ├── Timeout/Редирект: WebView
        ├── HTTP 404/403: Заглушка
        └── 🔄 Для возврата: CloakingConstants.restoreNormalMode()
        """
        } else {
            settings += """
        🎯 ОЖИДАЕМОЕ ПОВЕДЕНИЕ:
        ├── Первые 3 дня: Всегда заглушка (игра)
        ├── После 3 дней: Зависит от трекера
        ├── Timeout/Редирект: WebView (логично!)
        └── Реальные ошибки: Заглушка
        """
        }
        #else
        settings += """
        🎯 ОЖИДАЕМОЕ ПОВЕДЕНИЕ:
        ├── Первые 3 дня: Всегда заглушка (игра)
        ├── После 3 дней: Зависит от трекера
        ├── Timeout/Редирект: WebView (логично!)
        └── Реальные ошибки: Заглушка
        """
        #endif
        return settings
    }
    static func printProductionDiagnostics() {
        print("🚀 ===== PRODUCTION MODE DIAGNOSTICS =====")
        print(getCurrentSettings())
        print("🚀 ===== END PRODUCTION DIAGNOSTICS =====")
    }
}
extension CloakingConstants {
    static var isInProductionMode: Bool {
        #if DEBUG
        return !isTestMode && !forceWebView && !forceStubApp && mockDelayDays == -1 && !skipDelayCheck
        #else
        return true
        #endif
    }
    static var modeDescription: String {
        #if DEBUG
        if skipDelayCheck {
            return "🧪 TRACKER TEST MODE (no 3-day delay)"
        }
        #endif
        if isInProductionMode {
            return "🚀 PRODUCTION MODE"
        } else {
            return "🧪 DEBUG MODE"
        }
    }
} 