import Foundation

/// Styrer Opret konto skærmen. Det er skærmens logik: Kalder service, styrer loading og fejl.
@MainActor
@Observable
final class CreateAccountViewModel {
    enum AlertType: Identifiable, Hashable {
        case error(String)
        
        var id: Self { self }
    }
    
    private let sessionStore: SessionStore
    private let authService: AuthServiceProtocol
    
    var name = ""
    var email = ""
    var password = ""
    private(set) var isLoading = false
    var alert: AlertType?
    
    /// Knappen kan kun trykkes, når felterne er udfyldt, og den ikke loader.
    var isFormValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        !isLoading
    }
    
    init(sessionStore: SessionStore, authService: AuthServiceProtocol = AuthService()) {
        self.sessionStore = sessionStore
        self.authService = authService
    }
    
    /// Opretter kontoen og lader SessionStore bestemme, hvilken skærm der skal vises bagefter.
    func createAccount() async {
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            
            sessionStore.loadSession()
        } catch {
            alert = .error(error.localizedDescription)
        }
    }
}
