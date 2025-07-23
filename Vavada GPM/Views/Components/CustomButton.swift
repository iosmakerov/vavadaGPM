import SwiftUI
struct CustomButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            ZStack {
                ButtonBackgroundView()
                    .clipShape(RoundedRectangle(cornerRadius: 27))
                    .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 3)
                Text(title.uppercased())
                    .font(FontManager.buttonText)
                    .foregroundColor(ColorManager.white)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(height: 60)
    }
}
struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "CREATE LOBBY") {
        }
        .background(ColorManager.background)
    }
}