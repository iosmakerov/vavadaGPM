import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarItem(
                imageName: "tab_home_active",
                isSelected: selectedTab == 0,
                index: 0
            ) {
                selectedTab = 0
            }
            
            TabBarItem(
                imageName: "tab_icon_1",
                isSelected: selectedTab == 1,
                index: 1
            ) {
                selectedTab = 1
            }
            
            TabBarItem(
                imageName: "tab_icon_2",
                isSelected: selectedTab == 2,
                index: 2
            ) {
                selectedTab = 2
            }
            
            TabBarItem(
                imageName: "tab_icon_3",
                isSelected: selectedTab == 3,
                index: 3
            ) {
                selectedTab = 3
            }
        }
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(ColorManager.tabBarGradient)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
        )
        .ignoresSafeArea(.keyboard)
    }
}

struct TabBarItem: View {
    let imageName: String
    let isSelected: Bool
    let index: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isSelected ? ColorManager.primaryRed : ColorManager.inactiveGray)
                .frame(width: 36, height: 36)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(0))
            .background(ColorManager.background)
    }
} 