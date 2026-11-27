import Foundation

@MainActor
@Observable
final class EditShiftViewModel {
    enum AlertType: Identifiable, Hashable {
        case error(String)
        case missingEmployee
        case confirmDelete
        
        var id: Self { self }
    }
    
    private let userStore: UserStore
    private let shiftStore: ShiftStore
    private let shiftService: ShiftServiceProtocol
    
    var assignment: ShiftAssignment
    
    private(set) var isLoadingSave = false
    private(set) var isLoadingDelete = false
    var alert: AlertType?
    
    var isLoading: Bool {
        isLoadingSave || isLoadingDelete
    }
    
    init(shift: Shift, userStore: UserStore, shiftStore: ShiftStore, shiftService: ShiftServiceProtocol = ShiftService()) {
        self.userStore = userStore
        self.shiftStore = shiftStore
        self.shiftService = shiftService
        assignment = shift.status == .available ? .available : .employee
    }
    
    func editShift(shift: Shift) async -> Bool {
        guard let companyId = userStore.currentUser?.companyId else {
            alert = .error("Du er ikke tilmeldt en virksomhed.")
            return false
        }
        
        var shift = shift
        
        if assignment == .available {
            shift.status = .available
            shift.employeeId = nil
        } else if shift.employeeId == nil || (shift.employeeId ?? "").isEmpty  {
            alert = .missingEmployee
            return false
        } else if shift.employeeId == nil {
            alert = .missingEmployee
            return false
        } else if shift.status != .absent {
            shift.status = .assigned
        }
        
        let calendar = Calendar.current
        
        shift.endsAt = calendar.date(
            bySettingHour: calendar.component(.hour, from: shift.endsAt),
            minute: calendar.component(.minute, from: shift.endsAt),
            second: 0,
            of: shift.startsAt
        ) ?? shift.endsAt
        
        isLoadingSave = true
        
        defer { isLoadingSave = false }
        
        do {
            try await shiftService.editShift(companyId: companyId, shift: shift)
            
            if let index = shiftStore.shifts.firstIndex(where: { $0.id == shift.id }) {
                shiftStore.shifts[index] = shift
            }
            
            return true
        } catch {
            alert = .error(error.localizedDescription)
            return false
        }
    }
    
    func deleteShift(shift: Shift) async -> Bool {
        guard let companyId = userStore.currentUser?.companyId else {
            alert = .error("Du er ikke tilmeldt en virksomhed.")
            return false
        }
        
        isLoadingDelete = true
        
        defer { isLoadingDelete = false }
        
        do {
            try await shiftService.deleteShift(companyId: companyId, shift: shift)
            if let index = shiftStore.shifts.firstIndex(where: { $0.id == shift.id }) {
                shiftStore.shifts.remove(at: index)
            }
            return true
        } catch {
            alert = .error(error.localizedDescription)
            return false
        }
    }
}
