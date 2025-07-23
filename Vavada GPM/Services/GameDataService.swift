import Foundation
struct LobbyData: Codable {
    let code: String
    let playersCount: Int
    let createdAt: Date
    let isActive: Bool
    init(code: String, playersCount: Int) {
        self.code = code
        self.playersCount = playersCount
        self.createdAt = Date()
        self.isActive = true
    }
}
struct PitchHistory: Codable {
    let id: String
    let startupName: String
    let problemStatement: String
    let solution: String
    let whyNow: String
    let callToAction: String
    let rating: Int
    let createdAt: Date
    init(startupName: String, problemStatement: String, solution: String, whyNow: String, callToAction: String, rating: Int) {
        self.id = UUID().uuidString
        self.startupName = startupName
        self.problemStatement = problemStatement
        self.solution = solution
        self.whyNow = whyNow
        self.callToAction = callToAction
        self.rating = rating
        self.createdAt = Date()
    }
}
struct MarketState: Codable {
    var round: Int
    var trends: [String: TrendData]
    var lastUpdated: Date
    struct TrendData: Codable {
        var value: Int
        var isPositive: Bool
        var changeAmount: Int
    }
    init() {
        self.round = 1
        self.lastUpdated = Date()
        let coinNames = ["SnoutCoin", "Bacon Bucks", "House", "Health", "Wow", "Mug Gems", "Pearl Chips"]
        var initialTrends: [String: TrendData] = [:]
        for name in coinNames {
            initialTrends[name] = TrendData(
                value: Int.random(in: 0...5),
                isPositive: Bool.random(),
                changeAmount: Int.random(in: 1...3)
            )
        }
        self.trends = initialTrends
    }
}
class GameDataService: ObservableObject {
    static let shared = GameDataService()
    private init() {
        loadAllData()
    }
    private enum Keys {
        static let lobbies = "game_lobbies"
        static let pitchHistory = "pitch_history" 
        static let marketState = "market_state"
        static let appLaunchCount = "app_launch_count"
        static let lastLaunchDate = "last_launch_date"
        static let userStats = "user_stats"
    }
    @Published var currentMarketState = MarketState()
    @Published var activeLobby: LobbyData?
    @Published var recentPitches: [PitchHistory] = []
    @Published var currentPitchSession: PitchSessionData?
    func createLobby(playersCount: Int) -> String {
        let code = generateLobbyCode()
        let lobby = LobbyData(code: code, playersCount: playersCount)
        var lobbies = getStoredLobbies()
        lobbies.append(lobby)
        if lobbies.count > 10 {
            lobbies = Array(lobbies.suffix(10))
        }
        saveLobbies(lobbies)
        activeLobby = lobby
        return code
    }
    func joinLobby(code: String) -> Bool {
        let lobbies = getStoredLobbies()
        if let lobby = lobbies.first(where: { $0.code == code }) {
            activeLobby = lobby
            return true
        }
        if code.count == 6 && code.allSatisfy(\.isNumber) {
            let fakeLobby = LobbyData(code: code, playersCount: 2)
            activeLobby = fakeLobby
            return true
        }
        return false
    }
    private func generateLobbyCode() -> String {
        return String(Int.random(in: 100000...999999))
    }
    func startNewPitchSession() {
        currentPitchSession = PitchSessionData(
            startupName: "",
            logoCreated: false,
            problemStatement1: "",
            problemStatement2: "",
            ourSolution1: "",
            ourSolution2: "",
            whyNow1: "",
            whyNow2: "",
            callToAction1: "",
            callToAction2: ""
        )
    }
    func updatePitchSession(
        startupName: String = "",
        logoCreated: Bool = false,
        problemStatement1: String = "",
        problemStatement2: String = "",
        ourSolution1: String = "",
        ourSolution2: String = "",
        whyNow1: String = "",
        whyNow2: String = "",
        callToAction1: String = "",
        callToAction2: String = ""
    ) {
        guard let currentSession = currentPitchSession else { return }
        currentPitchSession = PitchSessionData(
            startupName: startupName.isEmpty ? currentSession.startupName : startupName,
            logoCreated: logoCreated || currentSession.logoCreated,
            problemStatement1: problemStatement1.isEmpty ? currentSession.problemStatement1 : problemStatement1,
            problemStatement2: problemStatement2.isEmpty ? currentSession.problemStatement2 : problemStatement2,
            ourSolution1: ourSolution1.isEmpty ? currentSession.ourSolution1 : ourSolution1,
            ourSolution2: ourSolution2.isEmpty ? currentSession.ourSolution2 : ourSolution2,
            whyNow1: whyNow1.isEmpty ? currentSession.whyNow1 : whyNow1,
            whyNow2: whyNow2.isEmpty ? currentSession.whyNow2 : whyNow2,
            callToAction1: callToAction1.isEmpty ? currentSession.callToAction1 : callToAction1,
            callToAction2: callToAction2.isEmpty ? currentSession.callToAction2 : callToAction2
        )
    }
    func completePitchSession(rating: Int) {
        guard let session = currentPitchSession else { return }
        let pitchHistory = session.toPitchHistory(rating: rating)
        recentPitches.insert(pitchHistory, at: 0)
        if recentPitches.count > 20 {
            recentPitches = Array(recentPitches.prefix(20))
        }
        savePitchHistory()
        currentPitchSession = nil
    }
    func savePitch(startupName: String, problemStatement: String, solution: String, whyNow: String, callToAction: String, rating: Int) {
        let pitch = PitchHistory(
            startupName: startupName,
            problemStatement: problemStatement,
            solution: solution,
            whyNow: whyNow,
            callToAction: callToAction,
            rating: rating
        )
        recentPitches.insert(pitch, at: 0)
        if recentPitches.count > 20 {
            recentPitches = Array(recentPitches.prefix(20))
        }
        savePitchHistory()
    }
    func nextMarketRound() {
        currentMarketState.round += 1
        currentMarketState.lastUpdated = Date()
        for (key, _) in currentMarketState.trends {
            let newValue = Int.random(in: 0...5)
            let isPositive = Bool.random()
            let changeAmount = Int.random(in: 1...3)
            currentMarketState.trends[key] = MarketState.TrendData(
                value: newValue,
                isPositive: isPositive,
                changeAmount: changeAmount
            )
        }
        saveMarketState()
    }
    func getMarketEvent() -> String {
        return MarketSimulatorData.getRandomEvent()
    }
    func recordAppLaunch() {
        let currentCount = UserDefaults.standard.integer(forKey: Keys.appLaunchCount)
        UserDefaults.standard.set(currentCount + 1, forKey: Keys.appLaunchCount)
        UserDefaults.standard.set(Date(), forKey: Keys.lastLaunchDate)
    }
    func getAppLaunchCount() -> Int {
        return UserDefaults.standard.integer(forKey: Keys.appLaunchCount)
    }
    func getLastLaunchDate() -> Date? {
        return UserDefaults.standard.object(forKey: Keys.lastLaunchDate) as? Date
    }
    private func loadAllData() {
        loadPitchHistory()
        loadMarketState()
        loadActivelobby()
    }
    private func getStoredLobbies() -> [LobbyData] {
        guard let data = UserDefaults.standard.data(forKey: Keys.lobbies),
              let lobbies = try? JSONDecoder().decode([LobbyData].self, from: data) else {
            return []
        }
        return lobbies
    }
    private func saveLobbies(_ lobbies: [LobbyData]) {
        if let data = try? JSONEncoder().encode(lobbies) {
            UserDefaults.standard.set(data, forKey: Keys.lobbies)
        }
    }
    private func loadActivelobby() {
    }
    private func loadPitchHistory() {
        guard let data = UserDefaults.standard.data(forKey: Keys.pitchHistory),
              let pitches = try? JSONDecoder().decode([PitchHistory].self, from: data) else {
            return
        }
        recentPitches = pitches
    }
    private func savePitchHistory() {
        if let data = try? JSONEncoder().encode(recentPitches) {
            UserDefaults.standard.set(data, forKey: Keys.pitchHistory)
        }
    }
    private func loadMarketState() {
        guard let data = UserDefaults.standard.data(forKey: Keys.marketState),
              let state = try? JSONDecoder().decode(MarketState.self, from: data) else {
            currentMarketState = MarketState()
            return
        }
        currentMarketState = state
    }
    private func saveMarketState() {
        if let data = try? JSONEncoder().encode(currentMarketState) {
            UserDefaults.standard.set(data, forKey: Keys.marketState)
        }
    }
}
extension String {
    var isNumber: Bool {
        return !isEmpty && allSatisfy { $0.isNumber }
    }
} 