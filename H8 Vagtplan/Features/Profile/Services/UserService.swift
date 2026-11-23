import Foundation
import FirebaseAuth
import FirebaseFirestore

/// Står for at hente brugeren med Firebase Firestore
nonisolated final class UserService: UserServiceProtocol {
    /// Henter den loggede ind bruger fra Firebase Firestore
    func fetchUser() async throws -> User {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw FirestoreError.unauthenticated
        }

        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            return try snapshot.data(as: User.self)
        } catch {
            throw FirestoreError(error: error)
        }
    }
}
