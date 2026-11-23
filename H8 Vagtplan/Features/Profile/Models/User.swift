import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let email: String
    let createdAt: Date
    let companyId: String?
    let role: UserRole?
    
    static let mockUser = User(name: "John Doe", email: "johndoe@mail.com", createdAt: .now, companyId: nil, role: .owner)
}
