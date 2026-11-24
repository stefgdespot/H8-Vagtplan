import Foundation
import FirebaseAuth
import FirebaseFirestore

/// Står for login, log ud og opret konto med Firebase Authentication og Firebase Firestore
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
    
    /// Opretter en konto med Firebase Authentication og Firebase Firestore.
    func createAccount(name: String, email: String, password: String) async throws {
        let result: AuthDataResult
        
        // Opretter kontoen i Firebase Authentication og gemmer resultatet
        do {
            result = try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            throw AuthError(error: error)
        }
        
        // Laver en User værdi
        let user = User(name: name, email: email, createdAt: .now, companyId: nil, role: nil)
        
        // Opretter kontoen i Firebase Firestore med samme id som resultatets user har fået. Kaster fejl og prøver at slette kontoen i Firebase Authentication, hvis det fejler.
        do {
            let data = try Firestore.Encoder().encode(user)
            
            try await Firestore.firestore().collection("users").document(result.user.uid).setData(data)
        } catch {
            try? await result.user.delete()
            throw FirestoreError(error: error)
        }
    }
}
