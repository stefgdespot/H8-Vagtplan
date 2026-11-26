import SwiftUI

struct EmployeeListView: View {
    @Environment(CompanyStore.self) private var companyStore
    @Environment(EmployeeStore.self) private var employeeStore
    
    @State private var employeeListViewModel: EmployeeListViewModel
    
    init(userStore: UserStore, employeeStore: EmployeeStore) {
        _employeeListViewModel = State(initialValue: EmployeeListViewModel(userStore: userStore, employeeStore: employeeStore))
    }
    
    private var employeeCountText: String {
        let count = employeeStore.employees.count
        return count == 1 ? "1 medarbejder" : "\(count) medarbejdere"
    }
    
    var body: some View {
        List {
            Section("Invitationskode") {
                switch companyStore.loadingState {
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                case .failed(let message):
                    errorCase(message: message)
                case .loaded(let company):
                    HStack {
                        Text(company.inviteCode)
                            .font(.headline)
                        
                        Spacer()
                        
                        ShareLink(item: company.inviteCode) {
                            Text("Del kode")
                                .font(.headline)
                                .foregroundStyle(.main)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
            switch employeeStore.loadingState {
            case .loading:
                Section("Medarbejdere") {
                    ProgressView("Henter medarbejdere...")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            case .failed(let message):
                Section("Medarbejdere") {
                    errorCase(message: message)
                }
            case .loaded(let users):
                Section(employeeCountText) {
                    if users.isEmpty {
                        ContentUnavailableView(
                            "Ingen medarbejdere",
                            systemImage: "person.2.slash",
                            description: Text("Der er ingen medarbejdere i virksomheden endnu.")
                        )
                    } else {
                        ForEach(users) { user in
                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .font(.headline)
                                
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .refreshable {
            await employeeListViewModel.refresh()
        }
        .navigationTitle("Medarbejdere")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func errorCase(message: String) -> some View {
        ContentUnavailableView(
            "Fejl",
            systemImage: "exclamationmark.triangle",
            description: Text(message)
        )
    }
}

#Preview("Success") {
    let userStore = UserStore()
    userStore.currentUser = .mockOwnerUser
    
    let companyStore = CompanyStore(companyService: MockCompanyService())
    companyStore.company = .mockCompany
    companyStore.loadingState = .loaded(.mockCompany)
    
    let employeeStore = EmployeeStore(employeeService: MockEmployeeService())
    
    return NavigationStack {
        EmployeeListView(userStore: userStore, employeeStore: employeeStore)
    }
    .environment(companyStore)
    .environment(employeeStore)
}

#Preview("Error") {
    let userStore = UserStore()
    userStore.currentUser = .mockOwnerUser
    
    let companyStore = CompanyStore(companyService: MockCompanyService())
    companyStore.company = .mockCompany
    companyStore.loadingState = .failed("Du har ikke adgang.")
    
    let employeeStore = EmployeeStore(employeeService: MockEmployeeService(error: FirestoreError.unknown))
    
    return NavigationStack {
        EmployeeListView(userStore: userStore, employeeStore: employeeStore)
    }
    .environment(companyStore)
    .environment(employeeStore)
}
