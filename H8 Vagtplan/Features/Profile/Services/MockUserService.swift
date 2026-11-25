import Foundation

/// Ligesom UserService, men med Mock logik. Den snakker ikke med Firebase, så man kan teste login uden at kalde Firebase.
/// Det bruges i Previews og tests.
nonisolated final class MockUserService: UserServiceProtocol {
    var error: Error?
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    func fetchUser() async throws -> User {
        if let error {
            throw error
        }
        
        return .mockOwnerUser
    }
}
