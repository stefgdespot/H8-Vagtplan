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
        
        return .mockOwnerUser
    }
    
    func joinCompany(code: String, user: User?) async throws -> User {
        if let error {
            throw error
        }
        
        return .mockOwnerUser
    }
    
    func fetchCompany(companyId: String) async throws -> Company {
        if let error {
            throw error
        }
        
        return .mockCompany
    }
}
