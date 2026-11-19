import Foundation
import FirebaseFirestore

enum FirestoreError: LocalizedError {
    case permissionDenied
    case unauthenticated
    case unavailable
    case deadlineExceeded
    case resourceExhausted
    case unknown

    init(error: Error) {
        let nsError = error as NSError

        guard nsError.domain == FirestoreErrorDomain, let code = FirestoreErrorCode.Code(rawValue: nsError.code) else {
            self = .unknown
            return
        }

        switch code {
        case .permissionDenied:
            self = .permissionDenied
        case .unauthenticated:
            self = .unauthenticated
        case .unavailable:
            self = .unavailable
        case .deadlineExceeded:
            self = .deadlineExceeded
        case .resourceExhausted:
            self = .resourceExhausted
        default:
            self = .unknown
        }
    }

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Du har ikke adgang til at gemme dataen."
        case .unauthenticated:
            return "Du er ikke logget ind. Log ind og prøv igen."
        case .unavailable:
            return "Serveren kan ikke nås lige nu. Prøv igen."
        case .deadlineExceeded:
            return "Det tog for lang tid. Prøv igen."
        case .resourceExhausted:
            return "For mange forespørgsler. Vent lidt og prøv igen."
        case .unknown:
            return "Noget gik galt. Prøv igen."
        }
    }
}
