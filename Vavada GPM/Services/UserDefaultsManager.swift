import Foundation
class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}
    func getFirstLaunchDate() -> Date {
        if let savedDate = UserDefaults.standard.object(forKey: CloakingConstants.firstLaunchDateKey) as? Date {
            return savedDate
        } else {
            let now = Date()
            UserDefaults.standard.set(now, forKey: CloakingConstants.firstLaunchDateKey)
            return now
        }
    }
    func getDaysFromFirstLaunch() -> Int {
        let firstLaunchDate = getFirstLaunchDate()
        return Calendar.current.dateComponents([.day], from: firstLaunchDate, to: Date()).day ?? 0
    }
    func isDelayPassed() -> Bool {
        return getDaysFromFirstLaunch() >= CloakingConstants.initialDelayDays
    }
    func getUserSessionData() -> UserSessionData {
        return UserSessionData(firstLaunchDate: getFirstLaunchDate())
    }
    func resetFirstLaunchDate() {
        UserDefaults.standard.removeObject(forKey: CloakingConstants.firstLaunchDateKey)
    }
    func setCustomFirstLaunchDate(_ date: Date) {
        UserDefaults.standard.set(date, forKey: CloakingConstants.firstLaunchDateKey)
    }
} 