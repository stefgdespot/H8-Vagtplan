import Foundation

@MainActor
@Observable
final class CreateCompanyViewModel {
    enum AlertType: Identifiable, Hashable {
        case error(String)
        
        var id: Self { self }
    }
    
    private let companyService: CompanyServiceProtocol
    
    var name = ""
    private(set) var isLoading = false
    var alert: AlertType?
    
    init(companyService: CompanyServiceProtocol = CompanyService()) {
        self.companyService = companyService
    }
    
    func createCompany() async {
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            try await companyService.createCompany()
        } catch {
            alert = .error(error.localizedDescription)
        }
    }
}
