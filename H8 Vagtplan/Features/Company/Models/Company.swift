import Foundation
import FirebaseFirestore

struct Company: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let inviteCode: String
    let createdAt: Date
    
    static let mockCompany = Company(name: "Fresh Finds", inviteCode: "X7K9Q2", createdAt: .now)
}
