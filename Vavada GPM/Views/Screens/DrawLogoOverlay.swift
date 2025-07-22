import SwiftUI

struct DrawLogoOverlay: View {
    @Binding var isPresented: Bool
    let onBackToMainMenu: (() -> Void)?
    @State private var paths: [Path] = []
    @State private var pathColors: [Int: Color] = [:]
    @State private var currentPath = Path()
    @State private var showBuildPitch = false
    @State private var currentColor = ColorManager.primaryRed
    @State private var lineWidth: CGFloat = 3
    @StateObject private var gameData = GameDataService.shared
    
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
                    // Заголовок и инструменты
                    VStack(spacing: 16) {
                        Text("Draw a logo")
                            .font(FontManager.titleLarge)
                            .foregroundColor(ColorManager.primaryRed)
                            .fontWeight(.bold)
                        
                        // Инструменты рисования
                        HStack(spacing: 16) {
                            // Color picker (упрощенный)
                            HStack(spacing: 8) {
                                ForEach([ColorManager.primaryRed, ColorManager.white, ColorManager.inactiveGray], id: \.self) { color in
                                    Button(action: {
                                        currentColor = color
                                    }) {
                                        Circle()
                                            .fill(color)
                                            .frame(width: 24, height: 24)
                                            .overlay(
                                                Circle()
                                                    .stroke(currentColor == color ? ColorManager.white : Color.clear, lineWidth: 2)
                                            )
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            // Undo button
                            Button(action: undoLastPath) {
                                Image(systemName: "arrow.uturn.backward")
                                    .font(.system(size: 16))
                                    .foregroundColor(paths.isEmpty ? ColorManager.inactiveGray : ColorManager.white)
                            }
                            .disabled(paths.isEmpty)
                            
                            // Clear button
                            Button(action: clearCanvas) {
                                Image(systemName: "trash")
                                    .font(.system(size: 16))
                                    .foregroundColor(paths.isEmpty ? ColorManager.inactiveGray : ColorManager.white)
                            }
                            .disabled(paths.isEmpty)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Область для рисования
                    ZStack {
                        // Фон области рисования
                        Rectangle()
                            .fill(Color(red: 0.25, green: 0.22, blue: 0.35))
                        
                        // Placeholder text когда canvas пустой
                        if paths.isEmpty && currentPath.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "scribble.variable")
                                    .font(.system(size: 40))
                                    .foregroundColor(ColorManager.inactiveGray)
                                
                                Text("Draw your startup logo")
                                    .font(.system(size: 16))
                                    .foregroundColor(ColorManager.inactiveGray)
                                
                                Text("Tap and drag to start drawing")
                                    .font(.system(size: 12))
                                    .foregroundColor(ColorManager.inactiveGray.opacity(0.7))
                            }
                        }
                        
                        // Canvas для рисования с сохранением цветов
                        Canvas { context, size in
                            for (index, path) in paths.enumerated() {
                                let color = pathColors[index] ?? ColorManager.primaryRed
                                context.stroke(path, with: .color(color), lineWidth: lineWidth)
                            }
                            context.stroke(currentPath, with: .color(currentColor), lineWidth: lineWidth)
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
                                    if !currentPath.isEmpty {
                                        paths.append(currentPath)
                                        pathColors[paths.count - 1] = currentColor
                                        currentPath = Path()
                                    }
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
                        // Сохраняем информацию о создании лого
                        let logoWasCreated = !paths.isEmpty
                        gameData.updatePitchSession(logoCreated: logoWasCreated)
                        showBuildPitch = true
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
        .overlay(
            // Модальное окно Build Your Pitch
            showBuildPitch ? BuildYourPitchOverlay(
                isPresented: $showBuildPitch, 
                onBackToMainMenu: onBackToMainMenu
            ) : nil
        )
    }
    
    // MARK: - Canvas Actions
    private func undoLastPath() {
        guard !paths.isEmpty else { return }
        let lastIndex = paths.count - 1
        paths.removeLast()
        pathColors.removeValue(forKey: lastIndex)
        
        // Перенумеровываем цвета путей
        let remainingColors = pathColors
        pathColors.removeAll()
        for (index, color) in remainingColors {
            if index < paths.count {
                pathColors[index] = color
            }
        }
    }
    
    private func clearCanvas() {
        paths.removeAll()
        pathColors.removeAll()
        currentPath = Path()
    }
}

struct DrawLogoOverlay_Previews: PreviewProvider {
    static var previews: some View {
        DrawLogoOverlay(isPresented: .constant(true), onBackToMainMenu: nil)
            .background(Color.gray) // Фон для демонстрации overlay
    }
} 