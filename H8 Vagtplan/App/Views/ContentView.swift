import SwiftUI

/// Appens første skærm. Den viser den skærm, som SessionStore bestemmer.
struct ContentView: View {
    @State private var contentViewModel: ContentViewModel
    @State private var sessionStore: SessionStore
    @State private var userStore: UserStore
    
    init(userService: UserServiceProtocol = UserService()) {
        let userStore = UserStore(userService: userService)
        let sessionStore = SessionStore(userStore: userStore)
        
        _contentViewModel = State(initialValue: ContentViewModel(sessionStore: sessionStore))
        _sessionStore = State(initialValue: sessionStore)
        _userStore = State(initialValue: userStore)
    }
    
    var body: some View {
        Group {
            switch sessionStore.screen {
            case .splash:
                ProgressView()
            case .login:
                LoginView(sessionStore: sessionStore)
            case .tab:
                ProfileView(sessionStore: sessionStore)
            case .companyWelcome:
                CompanyWelcomeView(sessionStore: sessionStore)
            }
        }
        .environment(userStore)
        .task {
            /// Kalder ContentViewModels loadSession, når skærmen vises, for at finde ud af om man er logget ind eller ikke logget ind.
            await contentViewModel.loadSession()
        }
        .alert(item: $contentViewModel.alert) { alert in
            switch alert {
            case .error(let message):
                Alert(title: Text("Fejl"), message: Text(message))
            }
        }
    }
}

#Preview("Success") {
    ContentView(userService: MockUserService())
}

#Preview("Failed") {
    ContentView(userService: MockUserService(error: FirestoreError.unknown))
}
