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
            Color.black.opacity(0.75)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            VStack(spacing: 0) {
                HStack {
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
                VStack(spacing: 24) {
                    HStack {
                        Text("Number of players")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.white)
                            .fontWeight(.bold)
                        Spacer()
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
                    VStack(spacing: 12) {
                        Text("Operation ID")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.white)
                            .fontWeight(.bold)
                        if isCreating {
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
                            Button(action: {
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
                    VStack(spacing: 12) {
                        Text("QR code")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.white)
                            .fontWeight(.bold)
                        Image("qr_code")
                            .resizable()
                            .interpolation(.none)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    VStack(spacing: 12) {
                        Text("Promo Codes")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.white)
                            .fontWeight(.bold)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            PromoCodeView(code: "NEWBIE25", discount: "25% OFF")
                            PromoCodeView(code: "WINNER50", discount: "50% OFF")
                            PromoCodeView(code: "GOLD100", discount: "100 COINS")
                            PromoCodeView(code: "BOOST30", discount: "30% BOOST")
                        }
                    }
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
                Color.clear
                    .frame(height: 100)
            }
        }
        .onAppear {
            if lobbyCreated && currentPlayers < numberOfPlayers {
                simulatePlayerJoining()
            }
        }
    }
    private func createLobby() {
        isCreating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            operationID = gameData.createLobby(playersCount: numberOfPlayers)
            isCreating = false
            lobbyCreated = true
            simulatePlayerJoining()
        }
    }
    private func simulatePlayerJoining() {
        guard lobbyCreated && currentPlayers < numberOfPlayers else { return }
        let delay = Double.random(in: 2.0...5.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if currentPlayers < numberOfPlayers {
                currentPlayers += 1
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
            .background(Color.gray)
    }
}