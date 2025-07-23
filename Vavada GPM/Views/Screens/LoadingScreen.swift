import SwiftUI
struct LoadingScreen: View {
    @State private var isAnimating = false
    @State private var loadingText = "Loading..."
    @State private var dots = ""
    var body: some View {
        ZStack {
            ColorManager.background
                .ignoresSafeArea(.all)
            VStack(spacing: 30) {
                Spacer()
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .stroke(ColorManager.primaryRed.opacity(0.3), lineWidth: 4)
                            .frame(width: 60, height: 60)
                        Circle()
                            .trim(from: 0, to: 0.8)
                            .stroke(
                                ColorManager.primaryRed,
                                style: StrokeStyle(lineWidth: 4, lineCap: .round)
                            )
                            .frame(width: 60, height: 60)
                            .rotationEffect(.degrees(isAnimating ? 360 : 0))
                            .animation(
                                Animation.linear(duration: 1.0).repeatForever(autoreverses: false),
                                value: isAnimating
                            )
                    }
                    Text(loadingText + dots)
                        .font(FontManager.body)
                        .foregroundColor(ColorManager.white)
                        .multilineTextAlignment(.center)
                }
                Spacer()
                VStack(spacing: 8) {
                    Text("Preparing content...")
                        .font(FontManager.caption)
                        .foregroundColor(ColorManager.textSecondary)
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(ColorManager.primaryRed.opacity(0.3))
                        .overlay(
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(ColorManager.primaryRed)
                                .scaleEffect(x: isAnimating ? 1.0 : 0.3, anchor: .leading)
                                .animation(
                                    Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                                    value: isAnimating
                                )
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    private func startAnimations() {
        isAnimating = true
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                switch dots {
                case "":
                    dots = "."
                case ".":
                    dots = ".."
                case "..":
                    dots = "..."
                default:
                    dots = ""
                }
            }
        }
    }
}
#Preview {
    LoadingScreen()
} 