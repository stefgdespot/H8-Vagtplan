import Foundation
import FirebaseAuth

/// Står for login med Firebase Authentication
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
}
