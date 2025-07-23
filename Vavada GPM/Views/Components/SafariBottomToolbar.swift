import SwiftUI

struct SafariBottomToolbar: View {
    let canGoBack: Bool
    let canGoForward: Bool
    let isLoading: Bool
    let onBackTapped: () -> Void
    let onForwardTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            // Кнопка Back
            Button(action: onBackTapped) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(canGoBack ? ColorManager.primaryRed : ColorManager.inactiveGray)
                    .frame(width: 44, height: 44)
            }
            .disabled(!canGoBack)
            
            Spacer()
            
            // Индикатор загрузки или состояние
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: ColorManager.primaryRed))
                    .scaleEffect(0.8)
                    .frame(width: 44, height: 44)
            } else {
                // Декоративная иконка или пустое место
                Image(systemName: "safari")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorManager.primaryRed.opacity(0.6))
                    .frame(width: 44, height: 44)
            }
            
            Spacer()
            
            // Кнопка Forward
            Button(action: onForwardTapped) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(canGoForward ? ColorManager.primaryRed : ColorManager.inactiveGray)
                    .frame(width: 44, height: 44)
            }
            .disabled(!canGoForward)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.95),
                            Color.black.opacity(0.9)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            // Верхняя граница
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.white.opacity(0.2)),
            alignment: .top
        )
    }
}

#Preview {
    VStack {
        Spacer()
        SafariBottomToolbar(
            canGoBack: true,
            canGoForward: false,
            isLoading: false,
            onBackTapped: {},
            onForwardTapped: {}
        )
    }
    .background(Color.gray)
} 