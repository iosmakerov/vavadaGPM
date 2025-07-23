import SwiftUI
struct AiSimulatorLoadingOverlay: View {
    @Binding var isPresented: Bool
    let onComplete: () -> Void
    @State private var progress: Double = 0.0
    @State private var isAnimating = false
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea(.all)
                .onTapGesture {
                }
            VStack(spacing: 24) {
                Text("Processing Your Pitch...")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(ColorManager.white)
                    .multilineTextAlignment(.center)
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 6)
                        .frame(width: 80, height: 80)
                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(
                            ColorManager.primaryRed,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                        .animation(
                            Animation.easeInOut(duration: 3.0),
                            value: progress
                        )
                }
                Text("Analyzing your startup concept...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.2, green: 0.18, blue: 0.25))
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
            )
            .padding(.horizontal, 40)
        }
        .onAppear {
            startLoading()
        }
    }
    private func startLoading() {
        withAnimation {
            progress = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            onComplete()
        }
    }
}