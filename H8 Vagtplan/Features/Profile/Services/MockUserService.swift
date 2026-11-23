import Foundation

/// Ligesom UserService, men med Mock logik. Den snakker ikke med Firebase, så man kan teste login uden at kalde Firebase.
/// Det bruges i Previews og tests.
nonisolated final class MockUserService: UserServiceProtocol {
    func fetchUser() async throws -> User {
        .mockUser
    }
}
