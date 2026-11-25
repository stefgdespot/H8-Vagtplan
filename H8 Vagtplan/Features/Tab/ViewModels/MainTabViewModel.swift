import Foundation

/// Styrer at hente virksomhed
@MainActor
@Observable
final class MainTabViewModel {
    enum AlertType: Identifiable, Hashable {
        case error(String)
        
        var id: Self { self }
    }
    
    private let companyStore: CompanyStore
    private let userStore: UserStore
    
    var selectedTab: TabItem = .dutySchedule
    var alert: AlertType?
    
    init(companyStore: CompanyStore, userStore: UserStore) {
        self.companyStore = companyStore
        self.userStore = userStore
    }
    
    func fetchCompany() async {
        guard let companyId = userStore.currentUser?.companyId else {
            alert = .error("Du er ikke tilmeldt en virksomhed.")
            return
        }
        
        do {
            try await companyStore.fetchCompany(companyId: companyId)
        } catch {
            alert = .error(error.localizedDescription)
        }
    }
}
