//
//  SessionStore.swift
//  H8 Vagtplan
//
//  Created by Stefan Gusatovic on 19/11/2026.
//

import Foundation
import FirebaseAuth

/// Holder styr på brugerens session og bestemmer, hvilken skærm appen viser.
@MainActor
@Observable
final class SessionStore {
    enum Screen {
        case splash
        case login
        case tab
    }
    
    var screen: Screen = .splash
    
    /// Tjekker om brugeren er logget ind, og viser den rigtige skærm.
    func loadSession() {
        if Auth.auth().currentUser != nil {
            screen = .tab
        } else {
            screen = .login
        }
    }
}
