import Foundation

/// Ligesom AuthService, men med Mock logik. Den snakker ikke med Firebase, så man kan teste authentication uden at kalde Firebase.
/// Det bruges i Previews og tests.
nonisolated final class MockAuthService: AuthServiceProtocol {
    /// Fejlen, som login skal kaste. Er den nil, er login successfuld.
    var error: Error?
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    /// Lader som om brugeren logger ind.
    func login(email: String, password: String) async throws {
        if let error {
            throw error
        }
        
        print("DEBUG: Logged in with email: \(email), and password: \(password)")
    }
    
    /// Lader som om brugeren logger ud
    func logout() throws {
        if let error {
            throw error
        }
        
        print("DEBUG: Logged out")
    }
    
    /// Lader som om brugeren opretter en konto
    func createAccount(name: String, email: String, password: String) async throws {
        if let error {
            throw error
        }
        
        print("DEBUG: Created user with name: \(name), with email: \(email), and password: \(password)")
    }
}
