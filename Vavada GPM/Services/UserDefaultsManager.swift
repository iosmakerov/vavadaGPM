import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}
    
    // MARK: - First Launch Management
    func getFirstLaunchDate() -> Date {
        if let savedDate = UserDefaults.standard.object(forKey: CloakingConstants.firstLaunchDateKey) as? Date {
            return savedDate
        } else {
            // Первый запуск - сохраняем текущую дату
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
    
    // MARK: - Session Data
    func getUserSessionData() -> UserSessionData {
        return UserSessionData(firstLaunchDate: getFirstLaunchDate())
    }
    
    // MARK: - Debug Methods (для тестирования)
    func resetFirstLaunchDate() {
        UserDefaults.standard.removeObject(forKey: CloakingConstants.firstLaunchDateKey)
    }
    
    func setCustomFirstLaunchDate(_ date: Date) {
        UserDefaults.standard.set(date, forKey: CloakingConstants.firstLaunchDateKey)
    }
} 