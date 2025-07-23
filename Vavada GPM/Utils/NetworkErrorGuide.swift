import Foundation
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