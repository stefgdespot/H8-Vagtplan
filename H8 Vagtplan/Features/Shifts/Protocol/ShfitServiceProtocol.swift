import Foundation

protocol ShiftServiceProtocol {
    func createShift(companyId: String, shift: Shift) async throws
    
    func fetchShifts(companyId: String) async throws -> [Shift]
}
