import Foundation
import FirebaseFirestore

/// Står for opret virksomhed med Firebase Firestore.
nonisolated final class CompanyService: CompanyServiceProtocol {
    
    /// Opretter en virksomhed i Firebase Firestore og giver brugeren et companyId og en role som chef.
    func createCompany(name: String, user: User?) async throws -> User {
        guard let user, let uid = user.id else {
            throw FirestoreError.unauthenticated
        }
        
        // Laver virksomheden og referencer til virksomhedens og brugerens dokumenter.
        let company = Company(name: name, inviteCode: String(UUID().uuidString.prefix(6)), createdAt: .now)
        let companyRef = Firestore.firestore().collection("companies").document()
        let userRef = Firestore.firestore().collection("users").document(uid)
        
        // Gemmer virksomheden i Firebase Firestore og putter companyId og role på brugeren i en batch, så enten kan begge gemmes, ellers bliver ingen af dem gemt.
        do {
            let data = try Firestore.Encoder().encode(company)
            let batch = Firestore.firestore().batch()
            
            batch.setData(data, forDocument: companyRef)
            batch.updateData([
                "companyId": companyRef.documentID,
                "role": UserRole.owner.rawValue
            ], forDocument: userRef)
            
            try await batch.commit()
            
            return User(id: uid, name: user.name, email: user.email, createdAt: user.createdAt, companyId: companyRef.documentID, role: .owner)
        } catch {
            throw FirestoreError(error: error)
        }
    }
}
