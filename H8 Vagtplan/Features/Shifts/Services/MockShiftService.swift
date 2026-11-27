import Foundation

nonisolated final class MockShiftService: ShiftServiceProtocol {
    var error: Error?
    var shift: Shift?
    var fetchCount = 0
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    func createShift(companyId: String, shift: Shift) async throws {
        if let error {
            throw error
        }
        
        self.shift = shift
    }
    
    func fetchShifts(companyId: String) async throws -> [Shift] {
        fetchCount += 1
        
        if let error {
            throw error
        }
        
        return Shift.mockShifts
    }
    
    func editShift(companyId: String, shift: Shift) async throws {
        if let error {
            throw error
        }
        
        self.shift = shift
    }
}
