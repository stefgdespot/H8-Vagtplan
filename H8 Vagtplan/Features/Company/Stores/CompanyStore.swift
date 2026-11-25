import Foundation

/// Holder styr på at hente virksomhed.
@MainActor
@Observable
final class CompanyStore {
    private let companyService: CompanyServiceProtocol
    
    var company: Company?
    
    init(companyService: CompanyServiceProtocol = CompanyService()) {
        self.companyService = companyService
    }
    
    func fetchCompany(companyId: String) async throws {
        company = try await companyService.fetchCompany(companyId: companyId)
    }
}
