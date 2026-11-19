//
//  AuthService.swift
//  H8 Vagtplan
//
//  Created by Stefan Gusatovic on 19/11/2026.
//

import Foundation
import FirebaseAuth

nonisolated final class AuthService: AuthServiceProtocol {
    func login(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            throw AuthError(error: error)
        }
    }
}
