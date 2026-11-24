import Foundation

@MainActor
@Observable
final class JoinCompanyViewModel {
    enum AlertType: Identifiable, Hashable {
        case error(String)
        
        var id: Self { self }
    }
    
    private let companyService: CompanyServiceProtocol
    
    var code = ""
    var alert: AlertType?
    
    private(set) var isLoading = false
    
    init(companyService: CompanyServiceProtocol = CompanyService()) {
        self.companyService = companyService
    }
    
    var isFormValid: Bool {
        !code.isEmpty &&
        !isLoading
    }
}
