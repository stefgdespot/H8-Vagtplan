import Foundation

@MainActor
@Observable
final class CreateCompanyViewModel {
    var name = ""
    private(set) var isLoading = false
}
