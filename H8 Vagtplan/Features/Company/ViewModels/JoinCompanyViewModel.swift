import Foundation

@MainActor
@Observable
final class JoinCompanyViewModel {
    enum AlertType: Identifiable, Hashable {
        case error(String)
        
        var id: Self { self }
    }
    
    private let sessionStore: SessionStore
    private let userStore: UserStore
    private let companyService: CompanyServiceProtocol
    
    var code = ""
    var alert: AlertType?
    
    private(set) var isLoading = false
    
    init(sessionStore: SessionStore, userStore: UserStore, companyService: CompanyServiceProtocol = CompanyService()) {
        self.sessionStore = sessionStore
        self.userStore = userStore
        self.companyService = companyService
    }
    
    var isFormValid: Bool {
        !code.isEmpty &&
        !isLoading
    }
    
    func joinCompany() async {
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            userStore.currentUser = try await companyService.joinCompany(code: code, user: userStore.currentUser)
            try await sessionStore.loadSession()
        } catch {
            alert = .error(error.localizedDescription)
        }
    }
}
