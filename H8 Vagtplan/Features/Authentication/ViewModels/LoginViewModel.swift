//
//  LoginViewModel.swift
//  H8 Vagtplan
//
//  Created by Stefan Gusatovic on 19/11/2026.
//

import Foundation

@MainActor
@Observable
final class LoginViewModel {
    enum AlertType: Identifiable, Hashable {
        case error(String)
        
        var id: Self { self }
    }
    
    private let authService: AuthServiceProtocol
    
    var email = ""
    var password = ""
    private(set) var isLoading = false
    var alert: AlertType?
    
    var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        !isLoading
    }
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
    
    func login() async {
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            try await authService.login(email: email, password: password)
        } catch {
            alert = .error(error.localizedDescription)
        }
    }
}
