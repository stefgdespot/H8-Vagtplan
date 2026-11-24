import SwiftUI

struct JoinCompanyView: View {
    @State private var joinCompanyViewModel: JoinCompanyViewModel
    
    init(companyService: CompanyServiceProtocol = CompanyService()) {
        _joinCompanyViewModel = State(initialValue: JoinCompanyViewModel(companyService: companyService))
    }
    
    var body: some View {
        Form {
            VStack(spacing: 16) {
                Image(systemName: "key")
                    .font(.system(size: 80))
                    .foregroundStyle(.main)
                
                VStack {
                    Text("Jeg har en kode")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Du får koden af din chef")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(Color.clear)
            
            Section("Invitationskode") {
                TextField("Skriv din invitationskode", text: $joinCompanyViewModel.code)
                    .autocorrectionDisabled()
            }
            
            Button {
                
            } label: {
                Group {
                    if joinCompanyViewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Tilmeld virksomhed")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 50)
                .font(.headline)
                .background(.main, in: .capsule)
                .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .disabled(!joinCompanyViewModel.isFormValid)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.immediately)
        .disabled(joinCompanyViewModel.isLoading)
        .navigationBarBackButtonHidden(joinCompanyViewModel.isLoading)
        .alert(item: $joinCompanyViewModel.alert) { alert in
            switch alert {
            case .error(let message):
                Alert(title: Text("Fejl"), message: Text(message))
            }
        }
    }
}

#Preview("Success") {
    JoinCompanyView(companyService: MockCompanyService())
}

#Preview("Failed") {
    JoinCompanyView(companyService: MockCompanyService(error: FirestoreError.unknown))
}
