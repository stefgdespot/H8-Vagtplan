import SwiftUI

/// Log ind skærmen. Skærmen viser felterne og knappen, mens LoginViewModel står for skærmens logik.
struct LoginView: View {
    @State private var loginViewModel: LoginViewModel
    
    private let sessionStore: SessionStore
    
    init(sessionStore: SessionStore, authService: AuthServiceProtocol = AuthService()) {
        _loginViewModel = State(initialValue: LoginViewModel(sessionStore: sessionStore, authService: authService))
        self.sessionStore = sessionStore
    }
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(spacing: 16) {
                    AppLogo()
                    
                    Text("Log ind")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                
                Section("Email") {
                    TextField("Skriv din email", text: $loginViewModel.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                Section("Adgangskode") {
                    SecureField("Skriv din adgangskode", text: $loginViewModel.password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                VStack(spacing: 30) {
                    Button {
                        Task {
                            await loginViewModel.login()
                        }
                    } label: {
                        Group {
                            if loginViewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Log ind")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 50)
                        .font(.headline)
                        .background(.main, in: .capsule)
                        .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                    .disabled(!loginViewModel.isFormValid)
                    
                    HStack(spacing: 4) {
                        Text("Har du ikke en konto?")

                        NavigationLink(value: AuthRoute.createAccount) {
                            Text("Opret konto")
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
            .disabled(loginViewModel.isLoading)
            .alert(item: $loginViewModel.alert) { alert in
                switch alert {
                case .error(let message):
                    Alert(title: Text("Fejl"), message: Text(message))
                }
            }
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .createAccount:
                    CreateAccountView(sessionStore: sessionStore)
                }
            }
        }
    }
}

/// Preview som logger en ind successfuldt med Mock logik.
#Preview("Success") {
    LoginView(sessionStore: SessionStore(), authService: MockAuthService())
}

/// Preview som kaster en fejl med Mock logik.
#Preview("Error") {
    LoginView(sessionStore: SessionStore(), authService: MockAuthService(error: AuthError.invalidCredential))
}
