import SwiftUI
struct ColorManager {
    static let background = Color(hex: "#171925")
    static let primaryRed = Color(hex: "#FE2948")
    static let secondaryRed = Color(hex: "#BF1D34")
    static let inactiveGray = Color(hex: "#BEB7C9")
    static let white = Color.white
    static let gradientPurple1 = Color(hex: "#473D55")
    static let gradientPurple2 = Color(hex: "#262233")
    static let textSecondary = Color(hex: "#BEB7C9")
    static let tabBackground = Color(hex: "#9D3C4A")
    static let buttonGradient = LinearGradient(
        colors: [primaryRed, secondaryRed],
        startPoint: .leading,
        endPoint: .trailing
    )
    static let tabBarGradient = LinearGradient(
        colors: [gradientPurple1, gradientPurple2],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}