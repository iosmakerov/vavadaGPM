import SwiftUI
struct TabContainerView: View {
    @State private var selectedTab: Int = 0
    var body: some View {
        ZStack {
            ColorManager.background
                .ignoresSafeArea(.all)
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case 0:
                        MainMenuScreen()
                    case 1:
                        MarketSimulatorScreen()
                    case 2:
                        RulesScreen()
                    case 3:
                        AboutScreen()
                    default:
                        MainMenuScreen()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
            }
        }
    }
}
struct TabContainerView_Previews: PreviewProvider {
    static var previews: some View {
        TabContainerView()
    }
}