import SwiftUI

struct EmployeeListView: View {
    @Environment(CompanyStore.self) private var companyStore
    
    @State private var employeeListViewModel: EmployeeListViewModel
    
    init(userStore: UserStore, employeeService: EmployeeServiceProtocol = EmployeeService()) {
        _employeeListViewModel = State(initialValue: EmployeeListViewModel(userStore: userStore, employeeService: employeeService))
    }
    
    private var employeeCountText: String {
        let count = employeeListViewModel.employees.count
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
                        
                        Button("Del kode") {
                            
                        }
                        .buttonStyle(.plain)
                        .font(.headline)
                        .foregroundStyle(.main)
                    }
                }
            }
            
            switch employeeListViewModel.loadingState {
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
        .task {
            await employeeListViewModel.fetchEmployees()
        }
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
    
    return NavigationStack {
        EmployeeListView(userStore: userStore, employeeService: MockEmployeeService())
    }
    .environment(CompanyStore(companyService: MockCompanyService()))
}

#Preview("Error") {
    let userStore = UserStore()
    userStore.currentUser = .mockOwnerUser
    
    return NavigationStack {
        EmployeeListView(userStore: userStore, employeeService: MockEmployeeService(error: FirestoreError.unknown))
    }
    .environment(CompanyStore(companyService: MockCompanyService(error: FirestoreError.unknown)))
}
