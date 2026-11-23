import SwiftUI

/// Profil skærmen. Skærmen viser brugerens oplysninger og Log ud knappen.
struct ProfileView: View {
    @State private var profileViewModel: ProfileViewModel
    
    init(sessionStore: SessionStore, authService: AuthServiceProtocol = AuthService()) {
        _profileViewModel = State(initialValue: ProfileViewModel(sessionStore: sessionStore, authService: authService))
    }
    
    var body: some View {
        Button("Log ud") {
            Task {
                await profileViewModel.logout()
            }
        }
    }
}

#Preview("Logout Success") {
    ProfileView(sessionStore: SessionStore(userStore: UserStore(userService: MockUserService())), authService: MockAuthService())
}

#Preview("Logout Error") {
    ProfileView(sessionStore: SessionStore(userStore: UserStore(userService: MockUserService(error: FirestoreError.unknown))), authService: MockAuthService(error: AuthError.unknown))
}
