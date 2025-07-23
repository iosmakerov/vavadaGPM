import SwiftUI
struct SafariBottomToolbar: View {
    let canGoBack: Bool
    let canGoForward: Bool
    let isLoading: Bool
    let onBackTapped: () -> Void
    let onForwardTapped: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 60) {
                Button(action: onBackTapped) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(canGoBack ? .blue : .gray)
                        .frame(width: 44, height: 44)
                }
                .disabled(!canGoBack)
                Button(action: onForwardTapped) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(canGoForward ? .blue : .gray)
                        .frame(width: 44, height: 44)
                }
                .disabled(!canGoForward)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color.white.opacity(0.3)),
                alignment: .top
            )
        }
        .background(Color.black.opacity(0.95))
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 0)
        }
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