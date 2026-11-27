import Foundation

@MainActor
@Observable
final class DutyScheduleViewModel {
    private let shiftStore: ShiftStore
    private let userStore: UserStore
    
    private(set) var loadingState: LoadingState<[Shift]> = .loading
    private(set) var hasLoaded = false
    
    init(shiftStore: ShiftStore, userStore: UserStore) {
        self.shiftStore = shiftStore
        self.userStore = userStore
    }
    
    func fetchShifts() async {
        guard !hasLoaded else { return }
        
        guard let companyId = userStore.currentUser?.companyId else {
            loadingState = .failed("Du er ikke tilmeldt en virksomhed.")
            return
        }
        
        do {
            try await shiftStore.fetchShifts(companyId: companyId)
            loadingState = .loaded(shiftStore.shifts)
            hasLoaded = true
        } catch {
            loadingState = .failed(error.localizedDescription)
        }
    }
    
    func refresh() async {
        hasLoaded = false
        await fetchShifts()
    }
}
