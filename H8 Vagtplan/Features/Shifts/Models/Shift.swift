import Foundation
import FirebaseFirestore

struct Shift: Identifiable, Codable {
    @DocumentID var id: String?
    let startsAt: Date
    let endsAt: Date
    let employeeId: String?
    let status: ShiftStatus
}
