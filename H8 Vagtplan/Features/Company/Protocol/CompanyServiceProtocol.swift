import Foundation

protocol CompanyServiceProtocol {
    func createCompany(name: String, user: User?) async throws -> User
    
    func joinCompany(code: String, user: User?) async throws -> User
}
