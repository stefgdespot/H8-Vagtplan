import Foundation

@MainActor
@Observable
final class EmployeeListViewModel {
    private let userStore: UserStore
    private let employeeService: EmployeeServiceProtocol
    
    private(set) var employees: [User] = []
    private(set) var loadingState: LoadingState<[User]> = .loading
    
    init(userStore: UserStore, employeeService: EmployeeServiceProtocol = EmployeeService()) {
        self.userStore = userStore
        self.employeeService = employeeService
    }
    
    func fetchEmployees() async {
        guard let companyId = userStore.currentUser?.companyId else {
            loadingState = .failed("Du er ikke tilmeldt en virksomhed.")
            return
        }
        
        do {
            employees = try await employeeService.fetchEmployees(companyId: companyId)
            loadingState = .loaded(employees)
        } catch {
            loadingState = .failed(error.localizedDescription)
        }
    }
}
