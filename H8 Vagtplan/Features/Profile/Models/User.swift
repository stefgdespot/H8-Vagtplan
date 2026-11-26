import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let email: String
    let createdAt: Date
    let companyId: String?
    let role: UserRole?
    
    static let mockOwnerUser = User(id: "ownerId", name: "John Doe", email: "johndoe@mail.com", createdAt: .now, companyId: "companyId", role: .owner)
    
    static let mockEmployeeUser = User(id: "employeeId", name: "John Doe", email: "johndoe@mail.com", createdAt: .now, companyId: "companyId", role: .employee)
}
