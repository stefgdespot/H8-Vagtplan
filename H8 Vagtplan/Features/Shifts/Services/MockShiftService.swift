import Foundation

nonisolated final class MockShiftService: ShiftServiceProtocol {
    var error: Error?
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    func createShift(companyId: String, shift: Shift) async throws {
        if let error {
            throw error
        }
    }
}
