import SwiftUI

struct CreateLobbyOverlay: View {
    @Binding var isPresented: Bool
    @State private var numberOfPlayers = 2
    @State private var operationID = ""
    @State private var isCreating = false
    @State private var lobbyCreated = false
    @State private var currentPlayers = 1
    @StateObject private var gameData = GameDataService.shared
    
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
                    // Number of players - интерактивный выбор
                    HStack {
                        Text("Number of players")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.white)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        // Кнопки для изменения количества игроков
                        HStack(spacing: 12) {
                            Button(action: {
                                if numberOfPlayers > 2 && !lobbyCreated {
                                    numberOfPlayers -= 1
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(numberOfPlayers > 2 && !lobbyCreated ? ColorManager.primaryRed : ColorManager.inactiveGray)
                            }
                            
                            Text("\(numberOfPlayers)")
                                .font(FontManager.body)
                                .foregroundColor(ColorManager.white)
                                .fontWeight(.bold)
                                .frame(width: 30)
                            
                            Button(action: {
                                if numberOfPlayers < 8 && !lobbyCreated {
                                    numberOfPlayers += 1
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(numberOfPlayers < 8 && !lobbyCreated ? ColorManager.primaryRed : ColorManager.inactiveGray)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(ColorManager.tabBarGradient)
                        )
                    }
                    
                    // Operation ID - с кнопкой создания
                    VStack(spacing: 12) {
                        Text("Operation ID")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.white)
                            .fontWeight(.bold)
                        
                        if isCreating {
                            // Состояние создания
                            HStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: ColorManager.primaryRed))
                                    .scaleEffect(0.8)
                                
                                Text("Creating...")
                                    .font(FontManager.body)
                                    .foregroundColor(ColorManager.white)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(ColorManager.tabBarGradient)
                            )
                        } else if lobbyCreated {
                            // Показываем созданный код
                            Button(action: {
                                // Копировать в буфер обмена
                                UIPasteboard.general.string = operationID
                            }) {
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
                        } else {
                            // Кнопка создания лобби
                            Button(action: createLobby) {
                                Text("CREATE LOBBY")
                                    .font(FontManager.body)
                                    .foregroundColor(ColorManager.white)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(ColorManager.primaryRed)
                                    )
                            }
                        }
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
                    
                    // Players status
                    if lobbyCreated {
                        VStack(spacing: 8) {
                            Text("Players: \(currentPlayers)/\(numberOfPlayers)")
                                .font(FontManager.body)
                                .foregroundColor(ColorManager.white)
                                .fontWeight(.bold)
                            
                            if currentPlayers < numberOfPlayers {
                                HStack {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: ColorManager.primaryRed))
                                        .scaleEffect(0.8)
                                    
                                    Text("Waiting for other players...")
                                        .font(.system(size: 14))
                                        .foregroundColor(ColorManager.textSecondary)
                                }
                            } else {
                                Text("All players joined! 🎉")
                                    .font(FontManager.body)
                                    .foregroundColor(ColorManager.primaryRed)
                                    .fontWeight(.bold)
                            }
                        }
                    } else {
                        Text("Set player count and create lobby")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.textSecondary)
                            .multilineTextAlignment(.center)
                    }
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
        .onAppear {
            // Симулируем добавление игроков каждые 3-5 секунд
            if lobbyCreated && currentPlayers < numberOfPlayers {
                simulatePlayerJoining()
            }
        }
    }
    
    // MARK: - Actions
    private func createLobby() {
        isCreating = true
        
        // Имитируем задержку создания лобби
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            operationID = gameData.createLobby(playersCount: numberOfPlayers)
            isCreating = false
            lobbyCreated = true
            
            // Начинаем симуляцию присоединения игроков
            simulatePlayerJoining()
        }
    }
    
    private func simulatePlayerJoining() {
        guard lobbyCreated && currentPlayers < numberOfPlayers else { return }
        
        let delay = Double.random(in: 2.0...5.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if currentPlayers < numberOfPlayers {
                currentPlayers += 1
                
                // Продолжаем симуляцию если нужно
                if currentPlayers < numberOfPlayers {
                    simulatePlayerJoining()
                }
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