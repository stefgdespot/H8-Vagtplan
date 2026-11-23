import SwiftUI

struct CompanyWelcomeView: View {
    @Environment(UserStore.self) private var userStore
    
    @State private var companyWelcomeViewModel: CompanyWelcomeViewModel
    
    init(sessionStore: SessionStore, authService: AuthServiceProtocol = AuthService()) {
        _companyWelcomeViewModel = State(initialValue: CompanyWelcomeViewModel(sessionStore: sessionStore, authService: authService))
    }
    
    var body: some View {
        NavigationStack {
            List {
                VStack(spacing: 16) {
                    AppLogo()
                    
                    VStack {
                        Text("Log ind")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Hvad vil du gøre?")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color.clear)
                
                Section {
                    NavigationLink(value: CompanyWelcomeRoute.createCompany) {
                        HStack(spacing: 12) {
                            Image(systemName: "building.2")
                                .font(.system(size: 24))
                                .foregroundStyle(.main)
                            
                            VStack(alignment: .leading) {
                                Text("Opret virksomhed")
                                    .font(.headline)
                                    
                                Text("Jeg er chef og vil lægge vagter ud")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
                
                Section {
                    NavigationLink(value: CompanyWelcomeRoute.joinCompany) {
                        HStack(spacing: 12) {
                            Image(systemName: "key")
                                .font(.system(size: 24))
                                .foregroundStyle(.main)
                            
                            VStack(alignment: .leading) {
                                Text("Jeg har en kode")
                                    .font(.headline)
                                    
                                Text("Min chef har givet mig en kode")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .safeAreaInset(edge: .bottom) {
                Button("Log ud") {
                    Task {
                        await companyWelcomeViewModel.logout()
                    }
                }
                .font(.headline)
                .foregroundStyle(.red)
            }
            .alert(item: $companyWelcomeViewModel.alert) { alert in
                switch alert {
                case .error(let message):
                    Alert(title: Text("Fejl"), message: Text(message))
                }
            }
            .navigationDestination(for: CompanyWelcomeRoute.self) { route in
                switch route {
                case .createCompany:
                    CreateCompanyView(userStore: userStore)
                case .joinCompany:
                    EmptyView()
                }
            }
        }
    }
}

#Preview("Success logout") {
    let userStore = UserStore(userService: MockUserService())
    
    CompanyWelcomeView(sessionStore: SessionStore(userStore: userStore), authService: MockAuthService())
        .environment(userStore)
}

#Preview("Failed logout") {
    let userStore = UserStore(userService: MockUserService(error: FirestoreError.unknown))
    
    CompanyWelcomeView(sessionStore: SessionStore(userStore: userStore), authService: MockAuthService(error: AuthError.unknown))
        .environment(userStore)
}
