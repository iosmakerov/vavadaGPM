import SwiftUI

struct AiSimulatorOverlay: View {
    @Binding var isPresented: Bool
    @State private var startupName = ""
    @State private var showDrawLogo = false
    
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
                VStack(spacing: 28) {
                    // Enter the startup's name
                    VStack(spacing: 20) {
                        Text("Enter the startup's name")
                            .font(FontManager.body)
                            .foregroundColor(ColorManager.white)
                            .fontWeight(.bold)
                        
                        // Поле ввода названия стартапа
                        TextField("House 321", text: $startupName)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(startupName.isEmpty ? Color(red: 0.4, green: 0.36, blue: 0.5) : ColorManager.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(red: 0.2, green: 0.18, blue: 0.3))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(red: 0.35, green: 0.32, blue: 0.45), lineWidth: 1)
                            )
                    }
                    
                    // Кнопка GENERATE справа от поля ввода
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            // Сгенерировать случайное название
                            let names = ["Tech Innovations", "Future Solutions", "Smart Systems", "Digital Ventures", "Next Gen Labs", "Quantum Labs", "AI Dynamics", "Data Fusion"]
                            startupName = names.randomElement() ?? "House 321"
                        }) {
                            ZStack {
                                // Фоновое изображение зеленой кнопки из дизайна
                                GreenButtonBackgroundView()
                                    .clipShape(RoundedRectangle(cornerRadius: 27))
                                    .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 3)
                                
                                Text("GENERATE")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(ColorManager.white)
                                    .fontWeight(.heavy)
                            }
                        }
                        .frame(width: 140, height: 60) // Фиксированная ширина - примерно 30% от полной ширины
                    }
                    .padding(.bottom, 4)
                    
                    // Кнопка SUBMIT на всю ширину
                    Button(action: {
                        if !startupName.isEmpty {
                            showDrawLogo = true
                        }
                    }) {
                        ZStack {
                            // Фоновое изображение кнопки из дизайна (как на главном экране)
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
            // Модальное окно Draw Logo
            showDrawLogo ? DrawLogoOverlay(
                isPresented: $showDrawLogo, 
                onBackToMainMenu: {
                    // Закрыть весь AI Simulator и вернуться на главный экран
                    isPresented = false
                }
            ) : nil
        )
    }
}

struct AiSimulatorOverlay_Previews: PreviewProvider {
    static var previews: some View {
        AiSimulatorOverlay(isPresented: .constant(true))
            .background(Color.gray) // Фон для демонстрации overlay
    }
} 