import Foundation

@MainActor
@Observable
final class EditShiftViewModel {
    enum AlertType: Identifiable, Hashable {
        case error(String)
        case missingEmployee
        
        var id: Self { self }
    }
    
    private let userStore: UserStore
    private let shiftStore: ShiftStore
    private let shiftService: ShiftServiceProtocol
    
    var assignment: ShiftAssignment
    
    private(set) var isLoading = false
    var alert: AlertType?
    
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
        } else if shift.employeeId == nil {
            alert = .missingEmployee
            return false
        } else if shift.status != .absent {
            shift.status = .assigned
        }
        
        isLoading = true
        
        defer { isLoading = false }
        
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
}
