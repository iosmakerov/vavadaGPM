import SwiftUI

struct RulesScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            // Заголовок RULES
            VStack {
                Text("RULES")
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
            
            // Основной контент с текстом
            ScrollView {
                VStack(spacing: 0) {
                    Text("""
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus.
""")
                    .font(FontManager.body)
                    .foregroundColor(ColorManager.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 40)
                }
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
}

struct RulesScreen_Previews: PreviewProvider {
    static var previews: some View {
        RulesScreen()
    }
} 