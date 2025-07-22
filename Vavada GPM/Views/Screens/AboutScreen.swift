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
                // Информация о приложении
                VStack(spacing: 12) {
                    Text("🐷 Viral Ventures")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(ColorManager.primaryRed)
                    
                    Text("A ridiculous tabletop game of fake ideas and very questionable investors.")
                        .font(FontManager.body)
                        .foregroundColor(ColorManager.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal, 20)
                }
                
                // Кредиты
                VStack(spacing: 8) {
                    Text("Designed by. AnedyStudio")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ColorManager.white)
                    
                    Text("Visual by. MariahArt")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ColorManager.white)
                }
                
                // Версия
                Text("App version: 1.00")
                    .font(.system(size: 18, weight: .bold))
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