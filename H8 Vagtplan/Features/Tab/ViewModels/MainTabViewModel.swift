import Foundation

/// Styrer at hente virksomhed
@MainActor
@Observable
final class MainTabViewModel {
    private let companyStore: CompanyStore
    private let employeeStore: EmployeeStore
    private let userStore: UserStore
    
    var selectedTab: TabItem = .dutySchedule
    
    init(companyStore: CompanyStore, employeeStore: EmployeeStore, userStore: UserStore) {
        self.companyStore = companyStore
        self.employeeStore = employeeStore
        self.userStore = userStore
        
        Task {
            await fetchCompany()
            await fetchEmployees()
        }
    }
    
    func fetchCompany() async {
        guard let companyId = userStore.currentUser?.companyId else {
            companyStore.loadingState = .failed("Du er ikke tilmeldt en virksomhed.")
            return
        }
        
        do {
            try await companyStore.fetchCompany(companyId: companyId)
            
            if let company = companyStore.company {
                companyStore.loadingState = .loaded(company)
            }
        } catch {
            companyStore.loadingState = .failed(error.localizedDescription)
        }
    }
    
    func fetchEmployees() async {
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
