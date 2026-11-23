import Foundation

@MainActor
@Observable
final class CreateCompanyViewModel {
    enum AlertType: Identifiable, Hashable {
        case error(String)
        
        var id: Self { self }
    }
    
    private let sessionStore: SessionStore
    private let userStore: UserStore
    private let companyService: CompanyServiceProtocol
    
    var name = ""
    private(set) var isLoading = false
    var alert: AlertType?
    
    init(sessionStore: SessionStore, userStore: UserStore, companyService: CompanyServiceProtocol = CompanyService()) {
        self.sessionStore = sessionStore
        self.userStore = userStore
        self.companyService = companyService
    }
    
    var isFormValid: Bool {
        !name.isEmpty &&
        !isLoading
    }
    
    func createCompany() async {
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            userStore.currentUser = try await companyService.createCompany(name: name, user: userStore.currentUser)
            try await sessionStore.loadSession()
        } catch {
            alert = .error(error.localizedDescription)
        }
    }
}
