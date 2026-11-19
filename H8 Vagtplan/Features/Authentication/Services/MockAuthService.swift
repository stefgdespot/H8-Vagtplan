//
//  MockAuthService.swift
//  H8 Vagtplan
//
//  Created by Stefan Gusatovic on 19/11/2026.
//

import Foundation

/// Ligesom AuthService, men med Mock logik. Den snakker ikke med Firebase, så man kan teste login uden at kalde Firebase.
/// Det bruges i Previews og tests.
nonisolated final class MockAuthService: AuthServiceProtocol {
    /// Fejlen, som login skal kaste. Er den nil, er login successfuld.
    var error: Error?
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    /// Lader som om brugeren logger ind.
    func login(email: String, password: String) async throws {
        if let error {
            throw error
        }
        
        print("DEBUG: Logged in")
    }
    
    /// Lader som om brugeren logger ud
    func logout() throws {
        if let error {
            throw error
        }
        
        print("DEBUG: Logged out")
    }
}
