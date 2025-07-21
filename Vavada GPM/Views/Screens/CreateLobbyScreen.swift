import SwiftUI

struct CreateLobbyOverlay: View {
    @Binding var isPresented: Bool
    @State private var numberOfPlayers = 2
    @State private var operationID = "986536"
    
    var body: some View {
        ZStack {
            // Полупрозрачный черный фон на весь экран
            Color.black.opacity(0.75)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 0) {
                // Заголовок вверху как навбар
                HStack {
                    // Кнопка назад
                    Button(action: { isPresented = false }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(ColorManager.primaryRed)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(ColorManager.white)
                            )
                    }
                    
                    Spacer()
                    
                    Text("CREATE LOBBY")
                        .font(FontManager.title)
                        .foregroundColor(ColorManager.white)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Невидимая кнопка для баланса
                    Color.clear
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(ColorManager.tabBarGradient)
                )
                
                Spacer()
                
                // Основная карточка с контентом - по центру
                VStack(spacing: 24) {
                    // Number of players
                    HStack {
                        Text("Number of players")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.white)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        // Выпадающий список (имитация)
                        HStack(spacing: 8) {
                            Text("\(numberOfPlayers)")
                                .font(FontManager.body)
                                .foregroundColor(ColorManager.white)
                                .fontWeight(.bold)
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(ColorManager.white)
                                .font(.system(size: 12, weight: .bold))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(ColorManager.tabBarGradient)
                        )
                    }
                    
                    // Operation ID
                    VStack(spacing: 12) {
                        Text("Operation ID")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.white)
                            .fontWeight(.bold)
                        
                        Text(operationID)
                            .font(.system(size: 28, weight: .bold, design: .monospaced))
                            .foregroundColor(ColorManager.primaryRed)
                            .tracking(6)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(ColorManager.primaryRed, lineWidth: 3)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(ColorManager.tabBarGradient)
                                    )
                            )
                    }
                    
                    // QR Code - центральный элемент
                    VStack(spacing: 12) {
                        Text("QR code")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.white)
                            .fontWeight(.bold)
                        
                        Image("qr_code-34d964")
                            .resizable()
                            .interpolation(.none)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    // Waiting message
                    Text("Waiting for other players...")
                        .font(FontManager.body)
                        .foregroundColor(ColorManager.white)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.35, green: 0.32, blue: 0.45))
                )
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 30)
                
                Spacer()
                
                // Пустое пространство снизу для таббара
                Color.clear
                    .frame(height: 100)
            }
        }
    }
}

struct CreateLobbyOverlay_Previews: PreviewProvider {
    static var previews: some View {
        CreateLobbyOverlay(isPresented: .constant(true))
            .background(Color.gray) // Фон для демонстрации overlay
    }
} 