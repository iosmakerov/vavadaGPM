import SwiftUI

struct MarketSimulatorScreen: View {
    @State private var coinItems = CoinItem.sampleData
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовок MARKET SIMULATOR
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
            
            // Основной контент
            VStack(spacing: 0) {
                // Lorem ipsum текст
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum dui augue, vulputate sed nibh ac, viverra finibus velit.")
                    .font(FontManager.body)
                    .foregroundColor(ColorManager.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                
                // Прокручиваемый список монет
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(coinItems) { coin in
                            CoinItemView(coin: coin)
                        }
                    }
                    .padding(.vertical, 10)
                }
                .frame(maxHeight: .infinity)
                
                // Точный отступ 32px между списком и кнопкой
                Spacer()
                    .frame(height: 32)
                
                // Кнопка NEXT ROUND
                CustomButton(title: "NEXT ROUND") {
                    // Перемешиваем значения для симуляции нового раунда
                    shuffleValues()
                }
                .padding(.horizontal, 20)
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
    }
    
    private func shuffleValues() {
        // Простая логика для симуляции изменений
        coinItems = coinItems.map { coin in
            let newValue = Int.random(in: 0...5)
            let isPositive = Bool.random()
            return CoinItem(
                name: coin.name,
                imageName: coin.imageName,
                value: newValue,
                isPositive: isPositive
            )
        }
    }
}

struct MarketSimulatorScreen_Previews: PreviewProvider {
    static var previews: some View {
        MarketSimulatorScreen()
    }
} 