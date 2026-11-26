import Foundation
import FirebaseFirestore

struct Shift: Identifiable, Codable {
    @DocumentID var id: String?
    let startsAt: Date
    let endsAt: Date
    let employeeId: String?
    let status: ShiftStatus
    
    static let mockShift = Shift(
        id: "shiftId",
        startsAt: Calendar.current.date(bySettingHour: 8, minute: 45, second: 0, of: .now) ?? .now,
        endsAt: Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: .now) ?? .now,
        employeeId: "employeeId",
        status: .assigned
    )
    
    static let mockShifts: [Shift] = [
        .init(id: "shiftId1", startsAt: mockShift.startsAt, endsAt: mockShift.endsAt, employeeId: "employeeId", status: .assigned),
        .init(id: "shiftId2", startsAt: mockShift.startsAt, endsAt: mockShift.endsAt, employeeId: "employeeId", status: .assigned),
        .init(id: "shiftId3", startsAt: mockShift.startsAt, endsAt: mockShift.endsAt, employeeId: "employeeId", status: .assigned),
        .init(id: "shiftId4", startsAt: mockShift.startsAt, endsAt: mockShift.endsAt, employeeId: "employeeId", status: .assigned),
        .init(id: "shiftId5", startsAt: mockShift.startsAt, endsAt: mockShift.endsAt, employeeId: "employeeId", status: .assigned)
    ]
}
