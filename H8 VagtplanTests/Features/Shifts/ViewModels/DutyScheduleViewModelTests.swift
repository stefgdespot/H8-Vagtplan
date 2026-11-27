import Testing
@testable import H8_Vagtplan

@MainActor
struct DutyScheduleViewModelTests {
    /// Unit test for at vagterne hentes når det lykkes.
    @Test("fetchShifts succeeds")
    func fetchShiftsLoadsShifts() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser
        
        let shiftStore = ShiftStore(shiftService: MockShiftService())
        let vm = DutyScheduleViewModel(shiftStore: shiftStore, userStore: userStore)
        
        await vm.fetchShifts()
        
        #expect(shiftStore.shifts.count == 5)
    }
}
