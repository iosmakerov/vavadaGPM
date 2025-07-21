import SwiftUI

struct DrawLogoOverlay: View {
    @Binding var isPresented: Bool
    @State private var paths: [Path] = []
    @State private var currentPath = Path()
    
    var body: some View {
        ZStack {
            // Полупрозрачный черный фон на весь экран
            Color.black.opacity(0.75)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 0) {
                // Заголовок вверху как навбар
                HStack {
                    // Кнопка назад
                    Button(action: { isPresented = false }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(ColorManager.primaryRed)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(ColorManager.white)
                            )
                    }
                    
                    Spacer()
                    
                    Text("AI SIMULATOR")
                        .font(FontManager.title)
                        .foregroundColor(ColorManager.white)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Невидимая кнопка для баланса
                    Color.clear
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(ColorManager.tabBarGradient)
                )
                
                Spacer()
                
                // Основная карточка с контентом - по центру
                VStack(spacing: 32) {
                    // Заголовок Draw a logo
                    Text("Draw a logo")
                        .font(FontManager.titleLarge)
                        .foregroundColor(ColorManager.primaryRed)
                        .fontWeight(.bold)
                    
                    // Область для рисования
                    ZStack {
                        // Фон области рисования
                        Rectangle()
                            .fill(Color(red: 0.25, green: 0.22, blue: 0.35))
                        
                        // Canvas для рисования
                        Canvas { context, size in
                            for path in paths {
                                context.stroke(path, with: .color(ColorManager.primaryRed), lineWidth: 3)
                            }
                            context.stroke(currentPath, with: .color(ColorManager.primaryRed), lineWidth: 3)
                        }
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let point = value.location
                                    if currentPath.isEmpty {
                                        currentPath.move(to: point)
                                    } else {
                                        currentPath.addLine(to: point)
                                    }
                                }
                                .onEnded { _ in
                                    paths.append(currentPath)
                                    currentPath = Path()
                                }
                        )
                    }
                    .frame(height: 400)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(ColorManager.primaryRed, lineWidth: 2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    // Кнопка SUBMIT
                    Button(action: {
                        print("Logo drawing submitted")
                        // Здесь будет переход к следующему экрану
                        isPresented = false
                    }) {
                        ZStack {
                            // Фоновое изображение кнопки из дизайна
                            ButtonBackgroundView()
                                .clipShape(RoundedRectangle(cornerRadius: 27))
                                .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 3)
                            
                            HStack(spacing: 12) {
                                Text("SUBMIT")
                                    .font(FontManager.buttonText)
                                    .foregroundColor(ColorManager.white)
                                    .fontWeight(.heavy)
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(ColorManager.white)
                                    .frame(width: 28, height: 28)
                                    .background(
                                        Circle()
                                            .fill(ColorManager.white.opacity(0.25))
                                    )
                            }
                        }
                    }
                    .frame(height: 60)
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 36)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.35, green: 0.32, blue: 0.45))
                )
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 25)
                
                Spacer()
                
                // Пустое пространство снизу для таббара
                Color.clear
                    .frame(height: 100)
            }
        }
    }
}

struct DrawLogoOverlay_Previews: PreviewProvider {
    static var previews: some View {
        DrawLogoOverlay(isPresented: .constant(true))
            .background(Color.gray) // Фон для демонстрации overlay
    }
} 