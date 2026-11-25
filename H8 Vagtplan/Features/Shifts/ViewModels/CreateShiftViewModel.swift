import Foundation

@MainActor
@Observable
final class CreateShiftViewModel {
    var date = Date()
    var startTime = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: .now) ?? .now
    var endTime = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: .now) ?? .now
    var assignment: ShiftAssignment = .employee
    var employee = ""
}
