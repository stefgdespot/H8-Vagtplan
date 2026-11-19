//
//  AuthServiceProtocol.swift
//  H8 Vagtplan
//
//  Created by Stefan Gusatovic on 19/11/2026.
//

import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws
    
    func logout() throws
}
