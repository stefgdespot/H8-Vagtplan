import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws
    
    func logout() throws
    
    func createAccount(name: String, email: String, password: String) async throws
}
