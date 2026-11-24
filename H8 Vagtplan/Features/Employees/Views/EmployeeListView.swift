import SwiftUI

struct EmployeeListView: View {
    @State private var employeeListViewModel: EmployeeListViewModel
    
    init(employeeService: EmployeeServiceProtocol = EmployeeService()) {
        _employeeListViewModel = State(initialValue: EmployeeListViewModel(employeeService: employeeService))
    }
    
    private var employeeCountText: String {
        let count = employeeListViewModel.employees.count
        return count == 1 ? "1 medarbejder" : "\(count) medarbejdere"
    }
    
    var body: some View {
        List {
            Section("Invitationskode") {
                HStack {
                    Text("X7K9Q2")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button("Del kode") {
                        
                    }
                    .buttonStyle(.plain)
                    .font(.headline)
                    .foregroundStyle(.main)
                }
            }
            
            Section(employeeCountText) {
                switch employeeListViewModel.loadingState {
                case .loading:
                    ProgressView("Henter medarbejdere...")
                        .frame(maxWidth: .infinity, alignment: .center)
                case .failed(let message):
                    ContentUnavailableView(
                        "Fejl",
                        systemImage: "exclamationmark.triangle",
                        description: Text(message)
                    )
                case .loaded(let users):
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
        .navigationTitle("Medarbejdere")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await employeeListViewModel.fetchEmployees()
        }
    }
}

#Preview("Success") {
    NavigationStack {
        EmployeeListView(employeeService: MockEmployeeService())
    }
}

#Preview("Error") {
    NavigationStack {
        EmployeeListView(employeeService: MockEmployeeService(error: FirestoreError.unknown))
    }
}
