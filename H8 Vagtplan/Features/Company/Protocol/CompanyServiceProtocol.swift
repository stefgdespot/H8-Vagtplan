import Foundation

protocol CompanyServiceProtocol {
    func createCompany(name: String, user: User?) async throws -> User
}
