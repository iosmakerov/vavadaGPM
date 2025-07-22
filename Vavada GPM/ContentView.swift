//
//  ContentView.swift
//  Vavada GPM
//
//  Created by Anton Makerov on 18.07.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var appState: AppState = .loading
    @StateObject private var cloakingService = CloakingService()
    
    var body: some View {
        Group {
            switch appState {
            case .loading:
                LoadingScreen()
                    .task {
                        await performCloakingCheck()
                    }
                
            case .webView(let url):
                WebViewScreen(url: url, appState: $appState)
                
            case .stubApp:
                TabContainerView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState)
    }
    
    private func performCloakingCheck() async {
        do {
            // Минимальная задержка для показа индикатора загрузки (только в продакшене)
            #if DEBUG
            if !CloakingConstants.skipLoadingDelay {
                try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 секунды
            }
            #else
            try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 секунды
            #endif
            
            let result = await cloakingService.checkAccess()
            
            await MainActor.run {
                switch result {
                case .showWebView(let url):
                    appState = .webView(url: url)
                case .showStubApp:
                    appState = .stubApp
                }
            }
        } catch {
            print("❌ Ошибка при проверке клоакинга: \(error)")
            await MainActor.run {
                appState = .stubApp
            }
        }
    }
}

#Preview {
    ContentView()
}
