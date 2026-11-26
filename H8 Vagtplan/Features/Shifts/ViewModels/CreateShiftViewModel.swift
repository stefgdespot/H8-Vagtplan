import Foundation

@MainActor
@Observable
final class CreateShiftViewModel {
    enum AlertType: Identifiable, Hashable {
        case error(String)
        
        var id: Self { self }
    }
    
    private let userStore: UserStore
    private let shiftService: ShiftServiceProtocol
    
    var date: Date = .now
    var startTime: Date = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: .now) ?? .now
    var endTime: Date = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: .now) ?? .now
    var assignment: ShiftAssignment = .employee
    var employee = ""
    
    var alert: AlertType?
    
    init(userStore: UserStore, shiftService: ShiftServiceProtocol = ShiftService()) {
        self.userStore = userStore
        self.shiftService = shiftService
    }
    
    func createShift() async {
        guard let companyId = userStore.currentUser?.companyId else {
            alert = .error("Du er ikke tilmeldt en virksomhed.")
            return
        }
        
        let calendar = Calendar.current
        
        let startsAt = calendar.date(
            bySettingHour: calendar.component(.hour, from: startTime),
            minute: calendar.component(.minute, from: startTime),
            second: 0,
            of: date
        ) ?? date
        
        let endsAt = calendar.date(
            bySettingHour: calendar.component(.hour, from: endTime),
            minute: calendar.component(.minute, from: endTime),
            second: 0,
            of: date
        ) ?? date
        
        let shift = Shift(
            startsAt: startsAt,
            endsAt: endsAt,
            employeeId: assignment == .available ? nil : employee,
            status: assignment == .available ? .available : .assigned
        )
        
        do {
            try await shiftService.createShift(companyId: companyId, shift: shift)
        } catch {
            alert = .error(error.localizedDescription)
        }
    }
}
