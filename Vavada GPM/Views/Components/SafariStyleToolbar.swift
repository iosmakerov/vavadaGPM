import SwiftUI

struct SafariStyleToolbar: View {
    let onBackTapped: () -> Void
    let title: String
    let isLoading: Bool
    
    init(title: String = "Загрузка...", isLoading: Bool = false, onBackTapped: @escaping () -> Void) {
        self.title = title
        self.isLoading = isLoading
        self.onBackTapped = onBackTapped
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Кнопка "Назад" в стиле Safari
            Button(action: onBackTapped) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ColorManager.primaryRed)
                    
                    Text("Назад")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(ColorManager.primaryRed)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            // Заголовок по центру
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: ColorManager.white))
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorManager.white)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            // Placeholder для симметрии (как кнопка назад)
            HStack {
                // Пустое место для центровки заголовка
            }
            .frame(width: 70) // Примерная ширина кнопки "Назад"
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                colors: [
                    Color.black.opacity(0.9),
                    Color.black.opacity(0.8)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(
            // Нижняя граница
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.white.opacity(0.2)),
            alignment: .bottom
        )
    }
}

#Preview {
    VStack(spacing: 0) {
        SafariStyleToolbar(
            title: "Vavada Casino",
            isLoading: false
        ) {
            print("Back tapped")
        }
        
        Rectangle()
            .foregroundColor(.gray)
        
        SafariStyleToolbar(
            title: "Загрузка страницы...",
            isLoading: true
        ) {
            print("Back tapped")
        }
    }
} 