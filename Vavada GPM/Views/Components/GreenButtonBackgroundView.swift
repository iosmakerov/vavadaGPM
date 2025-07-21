import SwiftUI

struct GreenButtonBackgroundView: View {
    var body: some View {
        Image("green_btn")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea(.all)
    }
} 