import SwiftUI
struct MainMenuScreen: View {
    @State private var showCreateLobby = false
    @State private var showJoinLobby = false
    @State private var showAiSimulator = false
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Spacer()
                Text("NAME")
                    .font(FontManager.titleLarge)
                    .foregroundColor(ColorManager.primaryRed)
                    .shadow(color: .white, radius: 1)
                Spacer()
                    .frame(height: 16)
            }
            .frame(height: 200)
            .background(
                Image("banner_coins-21e14d")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all, edges: .top)
                    .overlay(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0),
                                Color.black.opacity(0.7)
                            ],
                            startPoint: .init(x: 0.5, y: 0.4),
                            endPoint: .init(x: 0.5, y: 1.0)
                        )
                    )
            )
            VStack(spacing: 32) {
                                    CustomButton(title: "CREATE LOBBY") {
                        showCreateLobby = true
                    }
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    Image("gb_for_button_mainscreen")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                )
                .padding(.horizontal, 16)
                CustomButton(title: "JOIN THE LOBBY") {
                    showJoinLobby = true
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    Image("gb_for_button_mainscreen")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                )
                .padding(.horizontal, 16)
                CustomButton(title: "AI SIMULATOR") {
                    showAiSimulator = true
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    Image("gb_for_button_mainscreen")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                )
                .padding(.horizontal, 16)
            }
            .padding(.top, 80)
            .padding(.bottom, 32)
            Spacer()
        }
        .background(
            ColorManager.background
                .ignoresSafeArea(.all)
        )
        .overlay(
            showCreateLobby ? CreateLobbyOverlay(isPresented: $showCreateLobby) : nil
        )
        .overlay(
            showJoinLobby ? JoinLobbyOverlay(isPresented: $showJoinLobby) : nil
        )
        .overlay(
            showAiSimulator ? AiSimulatorOverlay(isPresented: $showAiSimulator) : nil
        )
    }
}
extension Text {
    func stroke(lineWidth: CGFloat) -> some View {
        self
            .background(
                self
                    .offset(x: -lineWidth, y: -lineWidth)
            )
            .background(
                self
                    .offset(x: lineWidth, y: -lineWidth)
            )
            .background(
                self
                    .offset(x: -lineWidth, y: lineWidth)
            )
            .background(
                self
                    .offset(x: lineWidth, y: lineWidth)
            )
    }
}
struct MainMenuScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuScreen()
    }
} 