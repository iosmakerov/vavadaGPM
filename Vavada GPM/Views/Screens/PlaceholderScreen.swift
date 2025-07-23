import SwiftUI
struct PlaceholderScreen: View {
    let title: String
    var body: some View {
        ZStack {
            ColorManager.background
                .ignoresSafeArea(.all)
            VStack(spacing: 20) {
                Text(title)
                    .font(FontManager.title)
                    .foregroundColor(ColorManager.white)
                Text("Coming Soon")
                    .font(FontManager.body)
                    .foregroundColor(ColorManager.inactiveGray)
            }
        }
    }
}
struct PlaceholderScreen_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderScreen(title: "Tab 2")
    }
}