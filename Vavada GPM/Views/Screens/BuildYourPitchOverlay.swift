import SwiftUI
import UIKit

struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor(ColorManager.tabBackground)
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        let parent: CustomTextEditor
        
        init(_ parent: CustomTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
    }
}

struct BuildYourPitchOverlay: View {
    @Binding var isPresented: Bool
    let onBackToMainMenu: (() -> Void)?
    
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
    
    // Состояния для лоадера и результатов
    @State private var showLoadingOverlay = false
    @State private var showResultOverlay = false
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
                                    field2: problemStatement2,
                                    onFieldTap: { fieldNumber in
                                        openTextInput(
                                            title: "Problem Statement \(fieldNumber)",
                                            binding: fieldNumber == 1 ? $problemStatement1 : $problemStatement2
                                        )
                                    },
                                    onGenerateTap: {
                                        generateProblemStatement()
                                    }
                                )
                                
                                PitchSection(
                                    title: "Our Solution",
                                    field1: ourSolution1,
                                    field2: ourSolution2,
                                    onFieldTap: { fieldNumber in
                                        openTextInput(
                                            title: "Our Solution \(fieldNumber)",
                                            binding: fieldNumber == 1 ? $ourSolution1 : $ourSolution2
                                        )
                                    },
                                    onGenerateTap: {
                                        generateSolution()
                                    }
                                )
                            }
                            
                            // Вторая строка: Why Now и Call to Action
                            HStack(spacing: 16) {
                                PitchSection(
                                    title: "Why Now",
                                    field1: whyNow1,
                                    field2: whyNow2,
                                    onFieldTap: { fieldNumber in
                                        openTextInput(
                                            title: "Why Now \(fieldNumber)",
                                            binding: fieldNumber == 1 ? $whyNow1 : $whyNow2
                                        )
                                    },
                                    onGenerateTap: {
                                        generateWhyNow()
                                    }
                                )
                                
                                PitchSection(
                                    title: "Call to Action",
                                    field1: callToAction1,
                                    field2: callToAction2,
                                    onFieldTap: { fieldNumber in
                                        openTextInput(
                                            title: "Call to Action \(fieldNumber)",
                                            binding: fieldNumber == 1 ? $callToAction1 : $callToAction2
                                        )
                                    },
                                    onGenerateTap: {
                                        generateCallToAction()
                                    }
                                )
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
                            // Сохраняем все данные питча перед отправкой
                            savePitchData()
                            showLoadingOverlay = true
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
        .overlay(
            // Лоадер экран
            showLoadingOverlay ? AnyView(
                AiSimulatorLoadingOverlay(isPresented: $showLoadingOverlay) {
                    showLoadingOverlay = false
                    showResultOverlay = true
                }
            ) : nil
        )
        .overlay(
            // Экран результатов с данными сессии
            showResultOverlay ? AnyView(
                AiSimulatorResultOverlay(
                    isPresented: $showResultOverlay,
                    pitchSession: gameData.currentPitchSession
                ) {
                    // Back to main menu - закрываем весь AI Simulator
                    if let onBackToMainMenu = onBackToMainMenu {
                        onBackToMainMenu()
                    } else {
                        isPresented = false
                    }
                }
            ) : nil
        )
    }
    
    private func openTextInput(title: String, binding: Binding<String>) {
        currentFieldTitle = title
        currentEditingText = binding.wrappedValue
        editingBinding = binding
        showTextInput = true
    }
    
    // MARK: - Generate Methods
    private func generateProblemStatement() {
        let randomStatement = PitchContentData.getRandomProblemStatement()
        if problemStatement1.isEmpty {
            problemStatement1 = randomStatement
        } else if problemStatement2.isEmpty {
            problemStatement2 = randomStatement
        } else {
            // Заменяем первое поле если оба заполнены
            problemStatement1 = randomStatement
        }
    }
    
    private func generateSolution() {
        let randomSolution = PitchContentData.getRandomSolution()
        if ourSolution1.isEmpty {
            ourSolution1 = randomSolution
        } else if ourSolution2.isEmpty {
            ourSolution2 = randomSolution
        } else {
            // Заменяем первое поле если оба заполнены
            ourSolution1 = randomSolution
        }
    }
    
    private func generateWhyNow() {
        let randomWhyNow = PitchContentData.getRandomWhyNow()
        if whyNow1.isEmpty {
            whyNow1 = randomWhyNow
        } else if whyNow2.isEmpty {
            whyNow2 = randomWhyNow
        } else {
            // Заменяем первое поле если оба заполнены
            whyNow1 = randomWhyNow
        }
    }
    
    private func generateCallToAction() {
        let randomCallToAction = PitchContentData.getRandomCallToAction()
        if callToAction1.isEmpty {
            callToAction1 = randomCallToAction
        } else if callToAction2.isEmpty {
            callToAction2 = randomCallToAction
        } else {
            // Заменяем первое поле если оба заполнены
            callToAction1 = randomCallToAction
        }
    }
    
    // MARK: - Save Pitch Data
    private func savePitchData() {
        gameData.updatePitchSession(
            problemStatement1: problemStatement1,
            problemStatement2: problemStatement2,
            ourSolution1: ourSolution1,
            ourSolution2: ourSolution2,
            whyNow1: whyNow1,
            whyNow2: whyNow2,
            callToAction1: callToAction1,
            callToAction2: callToAction2
        )
    }
}

// Компонент секции питча
struct PitchSection: View {
    let title: String
    let field1: String
    let field2: String
    let onFieldTap: (Int) -> Void
    let onGenerateTap: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Заголовок и Generate кнопка
            HStack {
                Spacer()
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(ColorManager.white)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            
            // Generate кнопка
            Button(action: onGenerateTap) {
                Text("Generate")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(ColorManager.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorManager.primaryRed)
                    )
            }
            
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
                
                CustomTextEditor(text: $text)
                    .frame(height: 150)
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
        BuildYourPitchOverlay(isPresented: .constant(true), onBackToMainMenu: nil)
    }
} 