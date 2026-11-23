import Foundation

@MainActor
@Observable
final class CreateCompanyViewModel {
    enum AlertType: Identifiable, Hashable {
        case error(String)
        
        var id: Self { self }
    }
    
    private let userStore: UserStore
    private let companyService: CompanyServiceProtocol
    
    var name = ""
    private(set) var isLoading = false
    var alert: AlertType?
    
    init(userStore: UserStore, companyService: CompanyServiceProtocol = CompanyService()) {
        self.userStore = userStore
        self.companyService = companyService
    }
    
    func createCompany() async {
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            userStore.currentUser = try await companyService.createCompany(name: name, user: userStore.currentUser)
        } catch {
            alert = .error(error.localizedDescription)
        }
    }
}
