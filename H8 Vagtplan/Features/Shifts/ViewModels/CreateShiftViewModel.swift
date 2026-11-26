import Foundation

@MainActor
@Observable
final class CreateShiftViewModel {
    enum AlertType: Identifiable, Hashable {
        case error(String)
        case missingEmployee
        
        var id: Self { self }
    }
    
    private let userStore: UserStore
    private let shiftService: ShiftServiceProtocol
    
    var date: Date = .now
    var startTime: Date = Calendar.current.date(bySettingHour: 8, minute: 45, second: 0, of: .now) ?? .now
    var endTime: Date = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: .now) ?? .now
    var assignment: ShiftAssignment = .employee
    var employeeId = ""
    
    var alert: AlertType?
    private(set) var isLoading = false
    
    init(userStore: UserStore, shiftService: ShiftServiceProtocol = ShiftService()) {
        self.userStore = userStore
        self.shiftService = shiftService
    }
    
    func createShift() async -> Bool {
        guard let companyId = userStore.currentUser?.companyId else {
            alert = .error("Du er ikke tilmeldt en virksomhed.")
            return false
        }
        
        if assignment == .employee && employeeId.isEmpty {
            alert = .missingEmployee
            return false
        }
        
        isLoading = true
        
        defer { isLoading = false }
        
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
            employeeId: assignment == .available ? nil : employeeId,
            status: assignment == .available ? .available : .assigned
        )
        
        do {
            try await shiftService.createShift(companyId: companyId, shift: shift)
            return true
        } catch {
            alert = .error(error.localizedDescription)
            return false
        }
    }
}
