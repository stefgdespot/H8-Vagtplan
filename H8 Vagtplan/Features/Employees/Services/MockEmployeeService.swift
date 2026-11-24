import Foundation

nonisolated final class MockEmployeeService: EmployeeServiceProtocol {
    var error: Error?
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    func fetchEmployees() async throws -> [User] {
        if let error {
            throw error
        }
        
        return [.mockEmployeeUser]
    }
}
