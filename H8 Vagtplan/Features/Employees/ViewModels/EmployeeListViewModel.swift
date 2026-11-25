import Foundation

/// Står for at hente medarbejderne for virksomheden.
@MainActor
@Observable
final class EmployeeListViewModel {
    private let userStore: UserStore
    private let employeeService: EmployeeServiceProtocol
    
    private(set) var employees: [User] = []
    private(set) var loadingState: LoadingState<[User]> = .loading
    private(set) var hasLoaded = false
    
    init(userStore: UserStore, employeeService: EmployeeServiceProtocol = EmployeeService()) {
        self.userStore = userStore
        self.employeeService = employeeService
    }
    
    func fetchEmployees() async {
        guard let companyId = userStore.currentUser?.companyId else {
            loadingState = .failed("Du er ikke tilmeldt en virksomhed.")
            return
        }
        
        guard !hasLoaded else { return }
        
        do {
            employees = try await employeeService.fetchEmployees(companyId: companyId)
            loadingState = .loaded(employees)
            hasLoaded = true
        } catch {
            loadingState = .failed(error.localizedDescription)
        }
    }
    
    func refresh() async {
        hasLoaded = false
        await fetchEmployees()
    }
}
