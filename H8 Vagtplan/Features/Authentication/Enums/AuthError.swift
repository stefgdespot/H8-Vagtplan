import Foundation
import FirebaseAuth

/// Appens egne Auth fejl med danske fejlbeskeder.
enum AuthError: LocalizedError {
    case wrongPassword
    case userNotFound
    case invalidCredential
    case invalidEmail
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case tooManyRequests
    case unknown

    /// Laver en Firebase fejl om til en AuthError.
    init(error: Error) {
        let nsError = error as NSError

        guard nsError.domain == AuthErrorDomain, let code = AuthErrorCode(rawValue: nsError.code) else {
            self = .unknown
            return
        }

        switch code {
        case .wrongPassword:
            self = .wrongPassword
        case .userNotFound:
            self = .userNotFound
        case .invalidCredential:
            self = .invalidCredential
        case .invalidEmail:
            self = .invalidEmail
        case .emailAlreadyInUse:
            self = .emailAlreadyInUse
        case .weakPassword:
            self = .weakPassword
        case .networkError:
            self = .networkError
        case .tooManyRequests:
            self = .tooManyRequests
        default:
            self = .unknown
        }
    }

    var errorDescription: String? {
        switch self {
        case .wrongPassword:
            return "Forkert adgangskode."
        case .userNotFound:
            return "Der findes ingen konto med den email."
        case .invalidCredential:
            return "Forkert email eller adgangskode."
        case .invalidEmail:
            return "Emailen er ikke gyldig."
        case .emailAlreadyInUse:
            return "Der findes allerede en konto med den email."
        case .weakPassword:
            return "Adgangskoden skal være mindst 6 tegn."
        case .networkError:
            return "Ingen forbindelse. Tjek dit internet og prøv igen."
        case .tooManyRequests:
            return "For mange forsøg. Vent lidt og prøv igen."
        case .unknown:
            return "Noget gik galt. Prøv igen."
        }
    }
}
