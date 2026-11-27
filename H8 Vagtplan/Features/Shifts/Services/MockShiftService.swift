import Foundation

nonisolated final class MockShiftService: ShiftServiceProtocol {
    var error: Error?
    var shift: Shift?
    var fetchCount = 0
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    func fetchShifts(companyId: String) async throws -> [Shift] {
        fetchCount += 1
        
        if let error {
            throw error
        }
        
        return Shift.mockShifts
    }
    
    func fetchEmployeeShifts(companyId: String, userId: String) async throws -> [Shift] {
        if let error {
            throw error
        }
        
        return Shift.mockShifts
    }
    
    func createShift(companyId: String, shift: Shift) async throws {
        if let error {
            throw error
        }
        
        self.shift = shift
    }
    
    func editShift(companyId: String, shift: Shift) async throws {
        if let error {
            throw error
        }
        
        self.shift = shift
    }
    
    func deleteShift(companyId: String, shift: Shift) async throws {
        if let error {
            throw error
        }
    }
}
