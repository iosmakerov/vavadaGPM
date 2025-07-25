import SwiftUI
struct MarketSimulatorScreen: View {
    @State private var coinItems = CoinItem.sampleData
    @StateObject private var gameData = GameDataService.shared
    @State private var showEventAlert = false
    @State private var currentEvent = ""
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text("MARKET SIMULATOR")
                    .font(FontManager.title)
                    .foregroundColor(ColorManager.white)
                    .fontWeight(.bold)
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(ColorManager.tabBarGradient)
            )
            .padding(.horizontal, 20)
            .padding(.top, 30)
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    HStack {
                        Text("Round \(gameData.currentMarketState.round)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(ColorManager.primaryRed)
                        Spacer()
                        if let lastUpdate = formatLastUpdate() {
                            Text(lastUpdate)
                                .font(.system(size: 12))
                                .foregroundColor(ColorManager.textSecondary)
                        }
                    }
                    .padding(.horizontal, 30)
                    Text(MarketSimulatorData.description)
                        .font(FontManager.body)
                        .foregroundColor(ColorManager.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                .padding(.top, 30)
                .padding(.bottom, 20)
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(coinItems.indices, id: \.self) { index in
                            let coin = coinItems[index]
                            let trendData = gameData.currentMarketState.trends[coin.name]
                            CoinItemView(coin: CoinItem(
                                name: coin.name,
                                imageName: coin.imageName,
                                value: trendData?.value ?? coin.value,
                                isPositive: trendData?.isPositive ?? coin.isPositive
                            ))
                        }
                    }
                    .padding(.vertical, 10)
                }
                .frame(maxHeight: .infinity)
                Spacer()
                    .frame(height: 32)
                VStack(spacing: 12) {
                    if !currentEvent.isEmpty {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(ColorManager.primaryRed)
                                .font(.system(size: 14))
                            Text("Event: \(currentEvent)")
                                .font(.system(size: 14))
                                .foregroundColor(ColorManager.white)
                                .lineLimit(2)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
                    CustomButton(title: "NEXT ROUND") {
                        nextMarketRound()
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 30)
            }
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(red: 0.35, green: 0.32, blue: 0.45))
            )
            .padding(.horizontal, 20)
            .padding(.top, 30)
            .padding(.bottom, 20)
        }
        .background(
            ColorManager.background
                .ignoresSafeArea(.all)
        )
        .alert("Market Event", isPresented: $showEventAlert) {
            Button("OK") {
                showEventAlert = false
            }
        } message: {
            Text(currentEvent)
        }
        .onAppear {
            loadMarketData()
        }
    }
    private func loadMarketData() {
        for (index, coin) in coinItems.enumerated() {
            if let trendData = gameData.currentMarketState.trends[coin.name] {
                coinItems[index] = CoinItem(
                    name: coin.name,
                    imageName: coin.imageName,
                    value: trendData.value,
                    isPositive: trendData.isPositive
                )
            }
        }
    }
    private func nextMarketRound() {
        gameData.nextMarketRound()
        currentEvent = gameData.getMarketEvent()
        loadMarketData()
        showEventAlert = true
        withAnimation(.easeInOut(duration: 0.5)) {
        }
    }
    private func formatLastUpdate() -> String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: gameData.currentMarketState.lastUpdated)
    }
}
struct MarketSimulatorScreen_Previews: PreviewProvider {
    static var previews: some View {
        MarketSimulatorScreen()
    }
}