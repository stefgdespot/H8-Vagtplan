import Foundation

/// Ligesom CompanyService, men med Mock logik. Den snakker ikke med Firebase, så man kan teste servicen uden at kalde Firebase.
/// Det bruges i Previews og tests.
nonisolated final class MockCompanyService: CompanyServiceProtocol {
    var error: Error?
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    func createCompany() async throws {
        if let error {
            throw error
        }
    }
}
