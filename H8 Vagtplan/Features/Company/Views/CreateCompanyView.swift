import SwiftUI

struct CreateCompanyView: View {
    @State private var createCompanyViewModel: CreateCompanyViewModel
    
    init(userStore: UserStore, companyService: CompanyServiceProtocol = CompanyService()) {
        _createCompanyViewModel = State(initialValue: CreateCompanyViewModel(userStore: userStore, companyService: companyService))
    }
    
    var body: some View {
        Form {
            VStack(spacing: 16) {
                Image(systemName: "building.2")
                    .font(.system(size: 80))
                    .foregroundStyle(.main)
                
                VStack {
                    Text("Opret virksomhed")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Du bliver chef og får en kode til dine medarbejdere")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(Color.clear)
            
            Section("Virksomhedsnavn") {
                TextField("Skriv dit virksomhedsnavn", text: $createCompanyViewModel.name)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
            }
            
            Button {
                Task {
                    await createCompanyViewModel.createCompany()
                }
            } label: {
                Group {
                    if createCompanyViewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Opret virksomhed")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 50)
                .font(.headline)
                .background(.main, in: .capsule)
                .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.immediately)
        .disabled(createCompanyViewModel.isLoading)
        .navigationBarBackButtonHidden(createCompanyViewModel.isLoading)
        .alert(item: $createCompanyViewModel.alert) { alert in
            switch alert {
            case .error(let message):
                Alert(title: Text("Fejl"), message: Text(message))
            }
        }
    }
}

#Preview("Success") {
    let userStore = UserStore(userService: MockUserService())
    userStore.currentUser = .mockUser
    
    return CreateCompanyView(userStore: userStore, companyService: MockCompanyService())
}

#Preview("Failed") {
    CreateCompanyView(userStore: UserStore(userService: MockUserService(error: FirestoreError.unknown)), companyService: MockCompanyService(error: FirestoreError.unknown))
}
