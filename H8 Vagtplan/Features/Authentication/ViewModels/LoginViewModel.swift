import Foundation

/// Styrer Log ind skærmen. Det er skærmens logik: Kalder service, styrer loading og fejl.
@MainActor
@Observable
final class LoginViewModel {
    enum AlertType: Identifiable, Hashable {
        case error(String)
        
        var id: Self { self }
    }
    
    private let sessionStore: SessionStore
    private let authService: AuthServiceProtocol
    
    var email = ""
    var password = ""
    private(set) var isLoading = false
    var alert: AlertType?
    
    /// Knappen kan kun trykkes, når felterne er udfyldt, og den ikke loader.
    var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        !isLoading
    }
    
    init(sessionStore: SessionStore, authService: AuthServiceProtocol = AuthService()) {
        self.sessionStore = sessionStore
        self.authService = authService
    }
    
    /// Logger brugeren ind og lader SessionStore bestemme, hvilken skærm der skal vises bagefter.
    func login() async {
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            try await authService.login(email: email, password: password)
            sessionStore.loadSession()
        } catch {
            alert = .error(error.localizedDescription)
        }
    }
}
