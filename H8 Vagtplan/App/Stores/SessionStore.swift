import Foundation
import FirebaseAuth

/// Holder styr på brugerens session og bestemmer, hvilken skærm appen viser.
@MainActor
@Observable
final class SessionStore {
    enum Screen {
        case splash
        case login
        case tab
    }
    
    private let userStore: UserStore
    
    var screen: Screen = .splash
    
    init(userStore: UserStore) {
        self.userStore = userStore
    }
    
    /// Tjekker om brugeren er logget ind, og viser den rigtige skærm.
    func loadSession() async throws {
        if Auth.auth().currentUser != nil {
            try await userStore.fetchUser()
            screen = .tab
        } else {
            screen = .login
        }
    }
}
