import Foundation

protocol UserServiceProtocol {
    func fetchUser() async throws -> User
}
