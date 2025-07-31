import SwiftUI
struct PromoCodeView: View {
    let code: String
    let discount: String
    @State private var isCopied = false
    var body: some View {
        Button(action: {
            UIPasteboard.general.string = code
            isCopied = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                isCopied = false
            }
        }) {
            VStack(spacing: 4) {
                Text(code)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(ColorManager.primaryRed)
                Text(discount)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(ColorManager.white)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isCopied ? ColorManager.primaryRed.opacity(0.3) : Color(red: 0.35, green: 0.32, blue: 0.45))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ColorManager.primaryRed, lineWidth: 1)
                    )
            )
        }
    }
}