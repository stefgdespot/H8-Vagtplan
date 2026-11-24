import Foundation

protocol EmployeeServiceProtocol {
    func fetchEmployees() async throws -> [User]
}
