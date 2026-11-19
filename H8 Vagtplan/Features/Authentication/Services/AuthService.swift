import Foundation
import FirebaseAuth

/// Står for login og log ud med Firebase Authentication
nonisolated final class AuthService: AuthServiceProtocol {
    
    /// Logger brugeren ind med email og adgangskode.
    func login(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            // Laver Firebase fejlen om til appens egen AuthError og kaster fejlen.
            throw AuthError(error: error)
        }
    }
    
    /// Logger brugeren ud
    func logout() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw AuthError(error: error)
        }
    }
    
    func createAccount(name: String, email: String, password: String) async throws {
        
    }
}
