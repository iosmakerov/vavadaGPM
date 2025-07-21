import SwiftUI

struct JoinLobbyOverlay: View {
    @Binding var isPresented: Bool
    @State private var enteredCode = ""
    
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
                    
                    Text("JOIN THE LOBBY")
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
                    // Entering a unique code
                    VStack(spacing: 16) {
                        Text("Entering a unique code")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.white)
                            .fontWeight(.bold)
                        
                        // Поле ввода кода
                        VStack(spacing: 8) {
                            // Темное поле для ввода
                            TextField("", text: $enteredCode)
                                .font(.system(size: 24, weight: .bold, design: .monospaced))
                                .foregroundColor(ColorManager.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.25, green: 0.22, blue: 0.35))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.4, green: 0.36, blue: 0.5), lineWidth: 1)
                                )
                            
                            // Красные черточки как в макете
                            HStack(spacing: 12) {
                                ForEach(0..<6, id: \.self) { _ in
                                    Rectangle()
                                        .fill(ColorManager.primaryRed)
                                        .frame(width: 20, height: 3)
                                        .cornerRadius(1.5)
                                }
                            }
                        }
                    }
                    
                    // QR Code для сканирования
                    VStack(spacing: 12) {
                        Text("QR code")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.white)
                            .fontWeight(.bold)
                        
                        // QR код в рамке
                        Image("qr_code-34d964")
                            .resizable()
                            .interpolation(.none)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 4)
                            )
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

struct JoinLobbyOverlay_Previews: PreviewProvider {
    static var previews: some View {
        JoinLobbyOverlay(isPresented: .constant(true))
            .background(Color.gray) // Фон для демонстрации overlay
    }
} 