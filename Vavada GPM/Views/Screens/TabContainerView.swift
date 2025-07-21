import SwiftUI

struct TabContainerView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            ColorManager.background
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                // Контент экранов
                Group {
                    switch selectedTab {
                    case 0:
                        MainMenuScreen()
                    case 1:
                        PlaceholderScreen(title: "Second Tab")
                    case 2:
                        PlaceholderScreen(title: "Third Tab")
                    case 3:
                        PlaceholderScreen(title: "Fourth Tab")
                    default:
                        MainMenuScreen()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Кастомный таббар
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