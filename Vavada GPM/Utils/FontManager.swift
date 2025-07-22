import SwiftUI

struct FontManager {
    // Системные шрифты для iOS
    // Используем системные шрифты для лучшей совместимости
    
    // Текстовые стили адаптированные для iPhone (удобочитаемые размеры)
    static let titleLarge = Font.system(size: 28, weight: .heavy, design: .default)
    static let buttonText = Font.system(size: 22, weight: .bold, design: .default)
    
    // Дополнительные размеры для интерфейса
    static let title = Font.system(size: 20, weight: .bold, design: .default)
    static let body = Font.system(size: 16, weight: .medium, design: .default)
    static let caption = Font.system(size: 14, weight: .regular, design: .default)
    static let button = Font.system(size: 16, weight: .medium, design: .default)
} 