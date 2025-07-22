import Foundation
import Network

@MainActor
class CloakingService: ObservableObject {
    private let userDefaultsManager = UserDefaultsManager.shared
    private let monitor = NWPathMonitor()
    
    init() {
        setupNetworkMonitor()
    }
    
    // MARK: - Main Cloaking Logic
    func checkAccess() async -> CloakingResult {
        print("🔍 CloakingService: Начинаю проверку доступа")
        
        #if DEBUG
        // Принудительные режимы для тестирования
        if CloakingConstants.forceWebView {
            print("🧪 DEBUG: Принудительно показываем веб-вью")
            return .showWebView(url: CloakingConstants.trackerURL)
        }
        
        if CloakingConstants.forceStubApp {
            print("🧪 DEBUG: Принудительно показываем белую часть")
            return .showStubApp
        }
        #endif
        
        // 1. Проверяем временные ограничения
        let sessionData = userDefaultsManager.getUserSessionData()
        print("📅 Дней с первого запуска: \(sessionData.daysFromFirstLaunch)")
        print("⏰ Задержка пройдена: \(sessionData.hasDelayPassed)")
        
        // Проверяем задержку (с возможностью мокания в DEBUG)
        let delayPassed: Bool
        #if DEBUG
        if CloakingConstants.mockDelayDays >= 0 {
            delayPassed = CloakingConstants.mockDelayDays >= CloakingConstants.initialDelayDays
            print("🧪 DEBUG: Мокаем дни (\(CloakingConstants.mockDelayDays)), задержка пройдена: \(delayPassed)")
        } else {
            delayPassed = sessionData.hasDelayPassed
        }
        #else
        delayPassed = sessionData.hasDelayPassed
        #endif
        
        guard delayPassed else {
            print("❌ Задержка не пройдена, показываем белую часть")
            return .showStubApp
        }
        
        // 2. Проверяем интернет соединение
        guard await checkInternetConnection() else {
            print("🌐 Нет интернета, показываем белую часть")
            return .showStubApp
        }
        
        // 3. Делаем запрос к трекеру
        print("🌍 Делаем запрос к трекеру: \(CloakingConstants.trackerURL)")
        let response = await makeTrackerRequest()
        
        switch response.statusCode {
        case 200, 401:
            // 200 - OK, 401 - Qrator защита (но доступ есть)
            print("✅ HTTP \(response.statusCode) - показываем веб-вью")
            return .showWebView(url: CloakingConstants.trackerURL)
        case 404, 403:
            // 404 - Not Found, 403 - Forbidden (заблокированное гео)
            print("❌ HTTP \(response.statusCode) - показываем белую часть")
            return .showStubApp
        case 301, 302, 307, 308:
            // Редиректы - показываем веб-вью
            print("🔄 HTTP \(response.statusCode) - редирект, показываем веб-вью")
            return .showWebView(url: CloakingConstants.trackerURL)
        default:
            print("⚠️ HTTP \(response.statusCode) - показываем белую часть по умолчанию")
            return .showStubApp
        }
    }
    
    // MARK: - Tracker Request
    private func makeTrackerRequest() async -> TrackerResponse {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        do {
            // Создаем запрос с правильными заголовками
            var request = URLRequest(url: URL(string: CloakingConstants.trackerURL)!)
            request.httpMethod = "GET"
            request.timeoutInterval = CloakingConstants.requestTimeoutSeconds
            
            // Добавляем заголовки для имитации реального браузера
            request.setValue(CloakingConstants.userAgent, forHTTPHeaderField: "User-Agent")
            request.setValue(CloakingConstants.acceptHeader, forHTTPHeaderField: "Accept")
            request.setValue(CloakingConstants.acceptLanguageHeader, forHTTPHeaderField: "Accept-Language")
            request.setValue("keep-alive", forHTTPHeaderField: "Connection")
            request.setValue("1", forHTTPHeaderField: "Upgrade-Insecure-Requests")
            
            print("📡 ===== ЗАПРОС К ТРЕКЕРУ =====")
            print("🌍 URL: \(CloakingConstants.trackerURL)")
            print("📋 Method: \(request.httpMethod ?? "GET")")
            print("⏱️ Timeout: \(request.timeoutInterval)s")
            print("📝 Headers:")
            if let headers = request.allHTTPHeaderFields {
                for (key, value) in headers {
                    print("   \(key): \(value)")
                }
            }
            print("🚀 Отправляем запрос...")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            let responseTime = CFAbsoluteTimeGetCurrent() - startTime
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 ===== ОТВЕТ ОТ ТРЕКЕРА =====")
                print("🎯 Status Code: \(httpResponse.statusCode)")
                print("⚡ Response Time: \(String(format: "%.2f", responseTime))s")
                print("📍 URL: \(httpResponse.url?.absoluteString ?? "N/A")")
                
                // Логируем заголовки ответа
                print("📋 Response Headers:")
                for (key, value) in httpResponse.allHeaderFields {
                    print("   \(key): \(value)")
                }
                
                // Логируем содержимое ответа (первые 500 символов)
                if !data.isEmpty {
                    if let responseString = String(data: data, encoding: .utf8) {
                        let truncatedResponse = responseString.count > 500 
                            ? String(responseString.prefix(500)) + "..." 
                            : responseString
                        print("📄 Response Body (\(data.count) bytes):")
                        print(truncatedResponse)
                    } else {
                        print("📄 Response Body: \(data.count) bytes (binary data)")
                    }
                } else {
                    print("📄 Response Body: Empty")
                }
                
                print("🔚 ===== КОНЕЦ ОТВЕТА =====")
                
                // Интерпретация результата
                switch httpResponse.statusCode {
                case 200:
                    print("✅ HTTP 200: Доступ разрешен - показываем веб-вью")
                case 401:
                    print("🔐 HTTP 401: Требует авторизации (Qrator защита) - показываем веб-вью")
                case 404:
                    print("❌ HTTP 404: Доступ запрещен - показываем белую часть")
                case 301, 302, 307, 308:
                    print("🔄 HTTP \(httpResponse.statusCode): Редирект - показываем веб-вью")
                case 403:
                    print("🚫 HTTP 403: Доступ запрещен - показываем белую часть")
                default:
                    print("⚠️ HTTP \(httpResponse.statusCode): Неожиданный код - показываем белую часть по умолчанию")
                }
                
                return TrackerResponse(statusCode: httpResponse.statusCode)
            } else {
                print("❌ Не удалось получить HTTP ответ")
                print("⚡ Response Time: \(String(format: "%.2f", responseTime))s")
                return TrackerResponse(statusCode: 0, error: CloakingError.invalidResponse)
            }
        } catch {
            let responseTime = CFAbsoluteTimeGetCurrent() - startTime
            print("❌ ===== ОШИБКА ЗАПРОСА =====")
            print("💥 Error: \(error)")
            print("📝 Localized Description: \(error.localizedDescription)")
            print("⚡ Time: \(String(format: "%.2f", responseTime))s")
            
            // Дополнительная информация об ошибке
            if let urlError = error as? URLError {
                print("🔍 URLError Code: \(urlError.code.rawValue)")
                print("🔍 URLError Description: \(urlError.localizedDescription)")
            }
            
            print("🔚 ===== КОНЕЦ ОШИБКИ =====")
            return TrackerResponse(statusCode: 0, error: error)
        }
    }
    
    // MARK: - Network Check
    private func checkInternetConnection() async -> Bool {
        return await withCheckedContinuation { continuation in
            let monitor = NWPathMonitor()
            let queue = DispatchQueue(label: "NetworkMonitor")
            var hasResumed = false
            
            monitor.pathUpdateHandler = { path in
                if !hasResumed {
                    hasResumed = true
                    let isConnected = path.status == .satisfied
                    monitor.cancel()
                    continuation.resume(returning: isConnected)
                }
            }
            
            monitor.start(queue: queue)
            
            // Таймаут для проверки соединения
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if !hasResumed {
                    hasResumed = true
                    monitor.cancel()
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
    private func setupNetworkMonitor() {
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}

// MARK: - Custom Errors
enum CloakingError: Error, LocalizedError {
    case networkUnavailable
    case invalidResponse
    case timeoutReached
    
    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "Сеть недоступна"
        case .invalidResponse:
            return "Некорректный ответ от сервера"
        case .timeoutReached:
            return "Превышено время ожидания"
        }
    }
} 