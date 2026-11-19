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
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        print("DEBUG: Logged in with user email: \(result.user.email ?? "No email")")
    }
}
