import Foundation

@MainActor
@Observable
final class DutyScheduleViewModel {
    private let shiftStore: ShiftStore
    private let userStore: UserStore
    
    private(set) var loadingState: LoadingState<[Shift]> = .loading
    
    init(shiftStore: ShiftStore, userStore: UserStore) {
        self.shiftStore = shiftStore
        self.userStore = userStore
    }
    
    func fetchShifts() async {
        guard let companyId = userStore.currentUser?.companyId else {
            loadingState = .failed("Du er ikke tilmeldt en virksomhed.")
            return
        }
        
        do {
            try await shiftStore.fetchShifts(companyId: companyId)
            loadingState = .loaded(shiftStore.shifts)
        } catch {
            loadingState = .failed(error.localizedDescription)
        }
    }
}
