import SwiftUI

struct BuildYourPitchOverlay: View {
    @Binding var isPresented: Bool
    
    // Состояния для текстовых полей
    @State private var problemStatement1 = ""
    @State private var problemStatement2 = ""
    @State private var ourSolution1 = ""
    @State private var ourSolution2 = ""
    @State private var whyNow1 = ""
    @State private var whyNow2 = ""
    @State private var callToAction1 = ""
    @State private var callToAction2 = ""
    
    // Модальное окно ввода текста
    @State private var showTextInput = false
    @State private var currentEditingText = ""
    @State private var currentFieldTitle = ""
    @State private var editingBinding: Binding<String>?
    
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
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Заголовок Build Your Pitch
                        Text("Build Your Pitch")
                            .font(FontManager.titleLarge)
                            .foregroundColor(ColorManager.primaryRed)
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        
                        // Основная карточка с секциями
                        VStack(spacing: 20) {
                            // Первая строка: Problem Statement и Our Solution
                            HStack(spacing: 16) {
                                PitchSection(
                                    title: "Problem Statement",
                                    field1: problemStatement1,
                                    field2: problemStatement2
                                ) { fieldNumber in
                                    openTextInput(
                                        title: "Problem Statement \(fieldNumber)",
                                        binding: fieldNumber == 1 ? $problemStatement1 : $problemStatement2
                                    )
                                }
                                
                                PitchSection(
                                    title: "Our Solution",
                                    field1: ourSolution1,
                                    field2: ourSolution2
                                ) { fieldNumber in
                                    openTextInput(
                                        title: "Our Solution \(fieldNumber)",
                                        binding: fieldNumber == 1 ? $ourSolution1 : $ourSolution2
                                    )
                                }
                            }
                            
                            // Вторая строка: Why Now и Call to Action
                            HStack(spacing: 16) {
                                PitchSection(
                                    title: "Why Now",
                                    field1: whyNow1,
                                    field2: whyNow2
                                ) { fieldNumber in
                                    openTextInput(
                                        title: "Why Now \(fieldNumber)",
                                        binding: fieldNumber == 1 ? $whyNow1 : $whyNow2
                                    )
                                }
                                
                                PitchSection(
                                    title: "Call to Action",
                                    field1: callToAction1,
                                    field2: callToAction2
                                ) { fieldNumber in
                                    openTextInput(
                                        title: "Call to Action \(fieldNumber)",
                                        binding: fieldNumber == 1 ? $callToAction1 : $callToAction2
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 0.35, green: 0.32, blue: 0.45))
                        )
                        .padding(.horizontal, 16)
                        
                        // Keyword Tags секция
                        VStack(spacing: 16) {
                            Text("Keyword Tags")
                                .font(FontManager.titleLarge)
                                .foregroundColor(ColorManager.primaryRed)
                                .fontWeight(.bold)
                            
                            // Теги в две строки
                            VStack(spacing: 12) {
                                HStack(spacing: 12) {
                                    KeywordTag(text: "#AI")
                                    KeywordTag(text: "#Bacon")
                                    KeywordTag(text: "#Sustainable")
                                    Spacer()
                                }
                                
                                HStack(spacing: 12) {
                                    KeywordTag(text: "#PigTech")
                                    KeywordTag(text: "#Hype")
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 0.35, green: 0.32, blue: 0.45))
                        )
                        .padding(.horizontal, 16)
                        
                        // Кнопка SUBMIT
                        Button(action: {
                            print("Pitch submitted")
                            isPresented = false
                        }) {
                            ZStack {
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
                        .padding(.horizontal, 25)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .overlay(
            // Модальное окно ввода текста
            showTextInput ? TextInputOverlay(
                isPresented: $showTextInput,
                title: currentFieldTitle,
                text: $currentEditingText
            ) { newText in
                editingBinding?.wrappedValue = newText
            } : nil
        )
    }
    
    private func openTextInput(title: String, binding: Binding<String>) {
        currentFieldTitle = title
        currentEditingText = binding.wrappedValue
        editingBinding = binding
        showTextInput = true
    }
}

// Компонент секции питча
struct PitchSection: View {
    let title: String
    let field1: String
    let field2: String
    let onFieldTap: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(ColorManager.white)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 8) {
                // Первое поле
                Button(action: { onFieldTap(1) }) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.5, green: 0.3, blue: 0.4))
                        .frame(height: 50)
                        .overlay(
                            Text(field1.isEmpty ? "" : String(field1.prefix(20)) + (field1.count > 20 ? "..." : ""))
                                .font(.system(size: 10))
                                .foregroundColor(ColorManager.white)
                                .padding(8)
                        )
                }
                
                // Второе поле
                Button(action: { onFieldTap(2) }) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.5, green: 0.3, blue: 0.4))
                        .frame(height: 50)
                        .overlay(
                            Text(field2.isEmpty ? "" : String(field2.prefix(20)) + (field2.count > 20 ? "..." : ""))
                                .font(.system(size: 10))
                                .foregroundColor(ColorManager.white)
                                .padding(8)
                        )
                }
            }
        }
    }
}

// Компонент тега
struct KeywordTag: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(ColorManager.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.5, green: 0.3, blue: 0.4))
            )
    }
}

// Модальное окно ввода текста
struct TextInputOverlay: View {
    @Binding var isPresented: Bool
    let title: String
    @Binding var text: String
    let onSave: (String) -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 24) {
                Text("Enter the text")
                    .font(FontManager.titleLarge)
                    .foregroundColor(ColorManager.white)
                    .fontWeight(.bold)
                
                TextEditor(text: $text)
                    .font(.system(size: 16))
                    .foregroundColor(ColorManager.white)
                    .padding(16)
                    .frame(height: 150)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.5, green: 0.3, blue: 0.4))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorManager.white, lineWidth: 2)
                    )
                
                Button("OK") {
                    onSave(text)
                    isPresented = false
                }
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorManager.white)
                .frame(width: 120, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(ColorManager.primaryRed)
                )
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.35, green: 0.32, blue: 0.45))
            )
            .padding(.horizontal, 32)
        }
    }
}

struct BuildYourPitchOverlay_Previews: PreviewProvider {
    static var previews: some View {
        BuildYourPitchOverlay(isPresented: .constant(true))
    }
} 