import SwiftUI

/// Opret konto skærmen. Skærmen viser felterne og knappen, mens CreateAccountViewModel står for skærmens logik.
struct CreateAccountView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var createAccountViewModel: CreateAccountViewModel
    
    init(sessionStore: SessionStore, authService: AuthServiceProtocol = AuthService()) {
        _createAccountViewModel = State(initialValue: CreateAccountViewModel(sessionStore: sessionStore, authService: authService))
    }
    
    var body: some View {
        Form {
            VStack(spacing: 16) {
                AppLogo()
                
                Text("Opret konto")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(Color.clear)
            
            Section("Navn") {
                TextField("Skriv dit navn", text: $createAccountViewModel.name)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
            }
            
            Section("Email") {
                TextField("Skriv din email", text: $createAccountViewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            
            Section("Adgangskode") {
                SecureField("Skriv din adgangskode", text: $createAccountViewModel.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            
            VStack(spacing: 30) {
                Button {
                    Task {
                        await createAccountViewModel.createAccount()
                    }
                } label: {
                    Group {
                        if createAccountViewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Opret konto")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 50)
                    .font(.headline)
                    .background(.main, in: .capsule)
                    .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
                .disabled(!createAccountViewModel.isFormValid)
                
                HStack(spacing: 4) {
                    Text("Har du allerede en konto?")
                        .foregroundStyle(.gray)
                    
                    Button("Log ind") {
                        dismiss()
                    }
                    .foregroundStyle(.main)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .navigationLinkIndicatorVisibility(.hidden)
            }
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.immediately)
        .disabled(createAccountViewModel.isLoading)
        .navigationBarBackButtonHidden(createAccountViewModel.isLoading)
        .alert(item: $createAccountViewModel.alert) { alert in
            switch alert {
            case .error(let message):
                Alert(title: Text("Fejl"), message: Text(message))
            }
        }
    }
}

/// Preview som opretter en konto successfuldt med Mock logik.
#Preview("Success") {
    CreateAccountView(sessionStore: SessionStore(userStore: UserStore(userService: MockUserService())), authService: MockAuthService())
}

/// Preview som kaster en fejl med Mock logik.
#Preview("Error") {
    CreateAccountView(sessionStore: SessionStore(userStore: UserStore(userService: MockUserService(error: FirestoreError.unknown))), authService: MockAuthService(error: AuthError.invalidEmail))
}
