import Foundation

@MainActor
@Observable
final class UserStore {
    private let userService: UserServiceProtocol
    
    var currentUser: User?
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func fetchUser() async throws {
        currentUser = try await userService.fetchUser()
    }
}
