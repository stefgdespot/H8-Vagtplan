import Foundation

/// Ligesom CompanyService, men med Mock logik. Den snakker ikke med Firebase, så man kan teste servicen uden at kalde Firebase.
/// Det bruges i Previews og tests.
nonisolated final class MockCompanyService: CompanyServiceProtocol {
    var error: Error?
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    func createCompany(name: String, user: User?) async throws -> User {
        if let error {
            throw error
        }
        
        guard let user else {
            throw FirestoreError.unauthenticated
        }
        
        return User(name: user.name, email: user.email, createdAt: user.createdAt, companyId: "companyId", role: .owner)
    }
}
