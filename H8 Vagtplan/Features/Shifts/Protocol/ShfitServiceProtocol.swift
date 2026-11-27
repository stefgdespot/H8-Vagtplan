import Foundation

protocol ShiftServiceProtocol {
    func fetchShifts(companyId: String) async throws -> [Shift]
    
    func fetchEmployeeShifts(companyId: String, userId: String) async throws -> [Shift]
    
    func createShift(companyId: String, shift: Shift) async throws
    
    func editShift(companyId: String, shift: Shift) async throws
    
    func deleteShift(companyId: String, shift: Shift) async throws
}
