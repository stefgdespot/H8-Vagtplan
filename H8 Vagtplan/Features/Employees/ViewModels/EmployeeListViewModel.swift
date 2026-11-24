import Foundation

@MainActor
@Observable
final class EmployeeListViewModel {
    private let employeeService: EmployeeServiceProtocol
    
    private(set) var employees: [User] = []
    private(set) var loadingState: LoadingState<[User]> = .loading
    
    init(employeeService: EmployeeServiceProtocol = EmployeeService()) {
        self.employeeService = employeeService
    }
    
    func fetchEmployees() async {
        do {
            employees = try await employeeService.fetchEmployees()
            loadingState = .loaded(employees)
        } catch {
            loadingState = .failed(error.localizedDescription)
        }
    }
}
