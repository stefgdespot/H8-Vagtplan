import Foundation

protocol EmployeeServiceProtocol {
    func fetchEmployees(companyId: String) async throws -> [User]
}
