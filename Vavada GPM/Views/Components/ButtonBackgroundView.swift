import SwiftUI

struct ButtonBackgroundView: View {
    var body: some View {
        Image("button_bg")
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

struct ButtonBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonBackgroundView()
            .frame(height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 27))
    }
} 