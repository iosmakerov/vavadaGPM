import SwiftUI

struct AboutScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            // Заголовок ABOUT
            VStack {
                Text("ABOUT")
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
            
            Spacer()
            
            // Центральный контент в карточке
            VStack(spacing: 30) {
                // Lorem ipsum текст
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean commodo ligula eget dolor.")
                    .font(FontManager.body)
                    .foregroundColor(ColorManager.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
                
                // Версия
                Text("V \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(ColorManager.white)
                
                // Кнопки
                VStack(spacing: 16) {
                    CustomButton(title: "SUPPORT") {
                        print("Support tapped")
                    }
                    
                    CustomButton(title: "PRIVACY POLICY") {
                        print("Privacy Policy tapped")
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 50)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(red: 0.35, green: 0.32, blue: 0.45))
            )
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(
            ColorManager.background
                .ignoresSafeArea(.all)
        )
    }
}

struct AboutScreen_Previews: PreviewProvider {
    static var previews: some View {
        AboutScreen()
    }
} 