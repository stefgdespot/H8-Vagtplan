import Foundation
import FirebaseFirestore

/// Står for at gemme vagter for virksomheden med Firebase Firestore.
nonisolated final class ShiftService: ShiftServiceProtocol {

    /// Gemmer vagten som et dokument i virksomhedens shifts subcollection.
    func createShift(companyId: String, shift: Shift) async throws {
        do {
            let data = try Firestore.Encoder().encode(shift)
            
            try await Firestore.firestore().collection("companies").document(companyId).collection("shifts").addDocument(data: data)
        } catch {
            throw FirestoreError(error: error)
        }
    }
}
