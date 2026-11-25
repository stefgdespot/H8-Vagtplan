import Foundation

/// Styrer at hente virksomhed
@MainActor
@Observable
final class MainTabViewModel {
    private let companyStore: CompanyStore
    private let userStore: UserStore
    
    var selectedTab: TabItem = .dutySchedule
    
    init(companyStore: CompanyStore, userStore: UserStore) {
        self.companyStore = companyStore
        self.userStore = userStore
        
        Task {
            await fetchCompany()
        }
    }
    
    func fetchCompany() async {
        guard let companyId = userStore.currentUser?.companyId else {
            companyStore.loadingState = .failed("Du er ikke tilmeldt en virksomhed.")
            return
        }
        
        companyStore.loadingState = .loading
        
        do {
            try await companyStore.fetchCompany(companyId: companyId)
            
            if let company = companyStore.company {
                companyStore.loadingState = .loaded(company)
            }
        } catch {
            companyStore.loadingState = .failed(error.localizedDescription)
        }
    }
}
