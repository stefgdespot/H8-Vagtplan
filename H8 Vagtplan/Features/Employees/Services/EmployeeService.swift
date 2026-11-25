import Foundation
import FirebaseFirestore

/// Står for at hente medarbejdere for virksomheden med Firebase Firestore.
nonisolated final class EmployeeService: EmployeeServiceProtocol {
    
    /// Henter medarbejderne og decoder dem en efter en til at være User model.
    func fetchEmployees(companyId: String) async throws -> [User] {
        do {
            let snapshot = try await Firestore.firestore().collection("users").whereField("companyId", isEqualTo: companyId).getDocuments()
            
            return try snapshot.documents.map { document in
                try document.data(as: User.self)
            }
        } catch {
            throw FirestoreError(error: error)
        }
    }
}
