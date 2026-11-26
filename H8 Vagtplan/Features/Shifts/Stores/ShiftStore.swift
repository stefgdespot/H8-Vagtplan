import Foundation

@MainActor
@Observable
final class ShiftStore {
    private let shiftService: ShiftServiceProtocol
    
    var shifts: [Shift] = []
    
    init(shiftService: ShiftServiceProtocol = ShiftService()) {
        self.shiftService = shiftService
    }
    
    func fetchShifts(companyId: String) async throws {
        shifts = try await shiftService.fetchShifts(companyId: companyId)
    }
}
