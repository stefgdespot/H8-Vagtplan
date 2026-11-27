import Foundation

/// Holder styr på at hente medarbejdere.
@MainActor
@Observable
final class EmployeeStore {
    private let employeeService: EmployeeServiceProtocol
    
    var employees: [User] = []
    var loadingState: LoadingState = .loading
    
    init(employeeService: EmployeeServiceProtocol = EmployeeService()) {
        self.employeeService = employeeService
    }
    
    func fetchEmployees(companyId: String) async throws {
        employees = try await employeeService.fetchEmployees(companyId: companyId)
    }
}
