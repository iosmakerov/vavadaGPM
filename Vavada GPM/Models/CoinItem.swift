import Foundation
struct CoinItem: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let value: Int
    let isPositive: Bool
    static let sampleData: [CoinItem] = [
        CoinItem(name: "SnoutCoin", imageName: "coin_snout", value: 2, isPositive: true),
        CoinItem(name: "Bacon Bucks", imageName: "coin_bacon", value: 3, isPositive: false),
        CoinItem(name: "House", imageName: "coin_house", value: 0, isPositive: false),
        CoinItem(name: "Health", imageName: "coin_health", value: 1, isPositive: true),
        CoinItem(name: "Wow", imageName: "coin_wow", value: 4, isPositive: false),
        CoinItem(name: "Mug Gems", imageName: "coin_mug", value: 2, isPositive: true),
        CoinItem(name: "Pearl Chips", imageName: "coin_pearl", value: 1, isPositive: false)
    ]
} 