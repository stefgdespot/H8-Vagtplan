//
//  MockAuthService.swift
//  H8 Vagtplan
//
//  Created by Stefan Gusatovic on 19/11/2026.
//

import Foundation

nonisolated final class MockAuthService: AuthServiceProtocol {
    var error: Error?
    
    init(error: Error? = nil) {
        self.error = error
    }
    
    func login(email: String, password: String) async throws {
        if let error {
            throw error
        }
        
        print("DEBUG: Logged in")
    }
}
