import Foundation
import FirebaseFirestore

struct Company: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let inviteCode: String
    let createdAt: Date
}

