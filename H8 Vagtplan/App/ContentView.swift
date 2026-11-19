import SwiftUI

/// Appens første skærm. Den viser den skærm, som SessionStore bestemmer.
struct ContentView: View {
    @State private var sessionStore = SessionStore()
    
    var body: some View {
        Group {
            switch sessionStore.screen {
            case .splash:
                ProgressView()
            case .login:
                LoginView(sessionStore: sessionStore)
            case .tab:
                Text("Tab")
            }
        }
        .onAppear {
            /// Kalder SessionStores loadSession, når skærmen vises, for at finde ud af om man er logget ind eller ikke logget ind.
            sessionStore.loadSession()
        }
    }
}

#Preview {
    ContentView()
}
