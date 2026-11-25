import Foundation

/// Ligesom EmployeeService, men med Mock logik. Den snakker ikke med Firebase, så man kan teste servicen uden at kalde Firebase.
/// Det bruges i Previews og tests.
nonisolated final class MockEmployeeService: EmployeeServiceProtocol {
    var error: Error?
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    func fetchEmployees(companyId: String) async throws -> [User] {
        if let error {
            throw error
        }
        
        return [.mockEmployeeUser]
    }
}
