import Foundation

/// Står for at hente medarbejderne for virksomheden.
@MainActor
@Observable
final class EmployeeListViewModel {
    private let userStore: UserStore
    private let employeeStore: EmployeeStore
    
    init(userStore: UserStore, employeeStore: EmployeeStore) {
        self.userStore = userStore
        self.employeeStore = employeeStore
    }
    
    func refresh() async {
        guard let companyId = userStore.currentUser?.companyId else {
            employeeStore.loadingState = .failed("Du er ikke tilmeldt en virksomhed.")
            return
        }
        
        do {
            try await employeeStore.fetchEmployees(companyId: companyId)
            employeeStore.loadingState = .loaded(employeeStore.employees)
        } catch {
            employeeStore.loadingState = .failed(error.localizedDescription)
        }
    }
}
