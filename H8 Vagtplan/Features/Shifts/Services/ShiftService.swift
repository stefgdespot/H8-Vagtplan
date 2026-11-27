import Foundation
import FirebaseFirestore

/// Står for at gemme vagter og hente vagter for virksomheden med Firebase Firestore.
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
    
    /// Henter vagter fra en virksomhed.
    func fetchShifts(companyId: String) async throws -> [Shift] {
        do {
            let snapshot = try await Firestore.firestore().collection("companies").document(companyId).collection("shifts").getDocuments()
            
            return try snapshot.documents.map { document in
                try document.data(as: Shift.self)
            }
        } catch {
            throw FirestoreError(error: error)
        }
    }
}
