import Foundation

/// Styrer Profil skærmen med log ud og fejl
@MainActor
@Observable
final class ProfileViewModel {
    enum AlertType: Identifiable, Hashable {
        case error(String)
        
        var id: Self { self }
    }
    
    private let sessionStore: SessionStore
    private let authService: AuthServiceProtocol
    
    var alert: AlertType?
    
    init(sessionStore: SessionStore, authService: AuthServiceProtocol = AuthService()) {
        self.sessionStore = sessionStore
        self.authService = authService
    }
    
    /// Logger brugeren ud og lader SessionStore sende brugeren tilbage til Log ind skærmen.
    func logout() async {
        do {
            try authService.logout()
            try await sessionStore.loadSession()
        } catch {
            alert = .error(error.localizedDescription)
        }
    }
}
