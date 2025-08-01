import SwiftUI
struct CoinItemView: View {
    let coin: CoinItem
    var body: some View {
        HStack(spacing: 16) {
            Image(coin.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Text(coin.name)
                .font(FontManager.body)
                .foregroundColor(ColorManager.white)
                .fontWeight(.bold)
            Spacer()
            HStack(spacing: 8) {
                Triangle()
                    .fill(ColorManager.primaryRed)
                    .frame(width: 12, height: 10)
                    .rotationEffect(.degrees(180))
                Text("\(coin.value)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(ColorManager.white)
                    .frame(minWidth: 20)
                Triangle()
                    .fill(Color.green)
                    .frame(width: 12, height: 10)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorManager.tabBarGradient)
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}
struct CoinItemView_Previews: PreviewProvider {
    static var previews: some View {
        CoinItemView(coin: CoinItem.sampleData[0])
            .background(ColorManager.background)
    }
}