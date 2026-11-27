import Foundation

@MainActor
@Observable
final class MyShiftsViewModel {
    private let userStore: UserStore
    private let shiftService: ShiftServiceProtocol
    
    private(set) var shifts: [Shift] = []
    private(set) var loadingState: LoadingState = .loading
    private(set) var hasLoaded = false
    
    init(userStore: UserStore, shiftService: ShiftServiceProtocol = ShiftService()) {
        self.userStore = userStore
        self.shiftService = shiftService
    }
    
    func fetchEmployeeShifts() async {
        guard !hasLoaded else { return }
        
        guard let userId = userStore.currentUser?.id else {
            loadingState = .failed("Du er ikke logget ind. Log ind og prøv igen.")
            return
        }
        
        guard let companyId = userStore.currentUser?.companyId else {
            loadingState = .failed("Du er ikke tilmeldt en virksomhed.")
            return
        }
        
        do {
            shifts = try await shiftService.fetchEmployeeShifts(companyId: companyId, userId: userId)
            loadingState = .loaded
            hasLoaded = true
        } catch {
            loadingState = .failed(error.localizedDescription)
        }
    }
    
    func refresh() async {
        hasLoaded = false
        await fetchEmployeeShifts()
    }
}
