import Foundation
struct TrackerResponse {
    let statusCode: Int
    let isAccessGranted: Bool
    let error: Error?
    let finalURL: String?
    init(statusCode: Int, error: Error? = nil, finalURL: String? = nil) {
        self.statusCode = statusCode
        self.isAccessGranted = statusCode == 200
        self.error = error
        self.finalURL = finalURL
    }
}
enum CloakingResult {
    case showWebView(url: String)
    case showStubApp
}
enum AppState: Equatable {
    case loading
    case webView(url: String)
    case stubApp
}
struct UserSessionData {
    let firstLaunchDate: Date
    let hasDelayPassed: Bool
    let daysFromFirstLaunch: Int
    init(firstLaunchDate: Date) {
        self.firstLaunchDate = firstLaunchDate
        let daysPassed = Calendar.current.dateComponents([.day], from: firstLaunchDate, to: Date()).day ?? 0
        self.daysFromFirstLaunch = daysPassed
        self.hasDelayPassed = daysPassed >= CloakingConstants.initialDelayDays
    }
} 