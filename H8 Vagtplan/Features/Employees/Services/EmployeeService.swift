import Foundation
import FirebaseFirestore

nonisolated final class EmployeeService: EmployeeServiceProtocol {
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
