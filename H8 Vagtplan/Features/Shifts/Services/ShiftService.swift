import Foundation
import FirebaseFirestore

/// Står for at oprette vagter, redigere vagter, slette vagter og hente vagter for virksomheden med Firebase Firestore.
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
    
    /// Redigere en vagt.
    func editShift(companyId: String, shift: Shift) async throws {
        guard let shiftId = shift.id else {
            throw FirestoreError.unknown
        }
        
        do {
            let data = try Firestore.Encoder().encode(shift)
            
            try await Firestore.firestore().collection("companies").document(companyId).collection("shifts").document(shiftId).updateData(data)
        } catch {
            throw FirestoreError(error: error)
        }
    }
    
    /// Sletter vagt fra databasen.
    func deleteShift(companyId: String, shift: Shift) async throws {
        guard let shiftId = shift.id else {
            throw FirestoreError.unknown
        }
        
        do {
            try await Firestore.firestore().collection("companies").document(companyId).collection("shifts").document(shiftId).delete()
        } catch {
            throw FirestoreError(error: error)
        }
    }
}
