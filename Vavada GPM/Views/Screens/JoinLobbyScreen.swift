import SwiftUI
enum JoinLobbyState {
    case entering
    case checking
    case success
    case failed
}
struct JoinLobbyOverlay: View {
    @Binding var isPresented: Bool
    @State private var enteredCode = ""
    @State private var joinState: JoinLobbyState = .entering
    @State private var errorMessage = ""
    @State private var joinedLobby: LobbyData?
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
                    Text("JOIN THE LOBBY")
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
                    VStack(spacing: 16) {
                        Text("Entering a unique code")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.white)
                            .fontWeight(.bold)
                        VStack(spacing: 8) {
                            TextField("Enter 6-digit code", text: $enteredCode)
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
                                        .stroke(getBorderColor(), lineWidth: 2)
                                )
                                .keyboardType(.numberPad)
                                .onChange(of: enteredCode) { value in
                                    if value.count > 6 {
                                        enteredCode = String(value.prefix(6))
                                    }
                                    if joinState == .failed {
                                        joinState = .entering
                                        errorMessage = ""
                                    }
                                }
                                .disabled(joinState == .checking)
                            HStack(spacing: 4) {
                                ForEach(0..<6, id: \.self) { index in
                                    Circle()
                                        .fill(index < enteredCode.count ? ColorManager.primaryRed : ColorManager.inactiveGray)
                                        .frame(width: 8, height: 8)
                                }
                            }
                            if joinState == .checking {
                                HStack {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: ColorManager.primaryRed))
                                        .scaleEffect(0.8)
                                    Text("Checking code...")
                                        .font(.system(size: 14))
                                        .foregroundColor(ColorManager.white)
                                }
                                .padding(.top, 8)
                            } else if enteredCode.count == 6 && joinState == .entering {
                                Button(action: joinLobby) {
                                    Text("JOIN LOBBY")
                                        .font(FontManager.body)
                                        .foregroundColor(ColorManager.white)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(ColorManager.primaryRed)
                                        )
                                }
                                .padding(.top, 8)
                            }
                            if joinState == .failed && !errorMessage.isEmpty {
                                Text(errorMessage)
                                    .font(.system(size: 12))
                                    .foregroundColor(ColorManager.primaryRed)
                                    .padding(.top, 4)
                            }
                        }
                    }
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
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 4)
                            )
                    }
                    switch joinState {
                    case .entering:
                        Text("Enter lobby code or scan QR")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.textSecondary)
                            .multilineTextAlignment(.center)
                    case .checking:
                        Text("Verifying lobby code...")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.white)
                            .multilineTextAlignment(.center)
                    case .success:
                        VStack(spacing: 8) {
                            Text("✅ Successfully joined!")
                                .font(FontManager.body)
                                .foregroundColor(ColorManager.primaryRed)
                                .fontWeight(.bold)
                            if let lobby = joinedLobby {
                                Text("Lobby: \(lobby.code)")
                                    .font(.system(size: 14))
                                    .foregroundColor(ColorManager.white)
                                Text("Players: \(lobby.playersCount)")
                                    .font(.system(size: 14))
                                    .foregroundColor(ColorManager.textSecondary)
                            }
                        }
                    case .failed:
                        VStack(spacing: 8) {
                            Text("❌ Failed to join")
                                .font(FontManager.body)
                                .foregroundColor(ColorManager.primaryRed)
                                .fontWeight(.bold)
                            Button("Try Again") {
                                joinState = .entering
                                enteredCode = ""
                                errorMessage = ""
                            }
                            .font(.system(size: 14))
                            .foregroundColor(ColorManager.primaryRed)
                            .padding(.top, 4)
                        }
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
    }
    private func getBorderColor() -> Color {
        switch joinState {
        case .entering:
            return enteredCode.count == 6 ? ColorManager.primaryRed : Color(red: 0.4, green: 0.36, blue: 0.5)
        case .checking:
            return ColorManager.primaryRed
        case .success:
            return ColorManager.primaryRed
        case .failed:
            return ColorManager.primaryRed.opacity(0.8)
        }
    }
    private func joinLobby() {
        guard enteredCode.count == 6 else { return }
        joinState = .checking
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let success = gameData.joinLobby(code: enteredCode)
            if success {
                joinedLobby = gameData.activeLobby
                joinState = .success
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    isPresented = false
                }
            } else {
                joinState = .failed
                errorMessage = "Lobby code not found. Please check the code and try again."
            }
        }
    }
}
struct JoinLobbyOverlay_Previews: PreviewProvider {
    static var previews: some View {
        JoinLobbyOverlay(isPresented: .constant(true))
            .background(Color.gray) 
    }
} 