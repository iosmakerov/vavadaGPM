import SwiftUI
enum StarRating: Int, CaseIterable {
    case oneTwoStars = 1
    case threeFourStars = 3
    case fiveStars = 5
    var characterImage: String {
        switch self {
        case .oneTwoStars:
            return "1starpig"
        case .threeFourStars:
            return "4-3starpig"
        case .fiveStars:
            return "5starpig"
        }
    }
    func starsImage(for actualStars: Int) -> String {
        return "\(actualStars)star"
    }
    var starCount: Int {
        switch self {
        case .oneTwoStars:
            return Int.random(in: 1...2)
        case .threeFourStars:
            return Int.random(in: 3...4)
        case .fiveStars:
            return 5
        }
    }
}
struct AiSimulatorResultOverlay: View {
    @Binding var isPresented: Bool
    let pitchSession: PitchSessionData?
    let onBackToMenu: () -> Void
    @State private var rating: StarRating = StarRating.allCases.randomElement()!
    @State private var actualStars: Int = 0
    @State private var starsImageName: String = ""
    @StateObject private var gameData = GameDataService.shared
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    onBackToMenu()
                }
            VStack(spacing: 16) {
                Image(rating.characterImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 180, height: 180)
                    .cornerRadius(16)
                Image(starsImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 35)
                    .padding(.bottom, 4)
                if let session = pitchSession {
                    VStack(spacing: 8) {
                        Text("\"\(session.startupName)\"")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(ColorManager.primaryRed)
                            .lineLimit(1)
                        Text(getDescriptionText())
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(ColorManager.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .padding(.horizontal, 16)
                        HStack(spacing: 4) {
                            Text("Completeness:")
                                .font(.system(size: 12))
                                .foregroundColor(ColorManager.textSecondary)
                            let percentage = Int(session.completionScore * 100)
                            Text("\(percentage)%")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(percentage > 80 ? ColorManager.primaryRed : ColorManager.textSecondary)
                        }
                    }
                } else {
                    Text(getDescriptionText())
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(ColorManager.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .padding(.horizontal, 16)
                }
                Button(action: {
                    savePitchResult()
                    onBackToMenu()
                }) {
                    ZStack {
                        ButtonBackgroundView()
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 3)
                        Text("BACK TO MENU")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(ColorManager.white)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(height: 50)
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.2, green: 0.18, blue: 0.25))
                    .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
            )
            .padding(.horizontal, 32)
        }
        .onAppear {
            actualStars = calculateRating()
            starsImageName = rating.starsImage(for: actualStars)
        }
    }
    private func getDescriptionText() -> String {
        let resultMessage = ResultMessageData.getMessage(for: actualStars)
        return resultMessage.message
    }
    private func calculateRating() -> Int {
        guard let session = pitchSession else {
            return rating.starCount
        }
        let completionScore = session.completionScore
        if completionScore >= 0.9 {
            return Bool.random() ? 5 : 4
        } else if completionScore >= 0.7 {
            return Bool.random() ? 4 : 3
        } else if completionScore >= 0.5 {
            return Bool.random() ? 3 : 2
        } else {
            return Bool.random() ? 2 : 1
        }
    }
    private func savePitchResult() {
        guard pitchSession != nil else { return }
        gameData.completePitchSession(rating: actualStars)
    }
}