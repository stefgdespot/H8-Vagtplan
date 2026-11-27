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
    
    /// Unit test for at vagterne ikke hentes når det fejler.
    @Test("fetchShifts fails")
    func fetchShiftsFails() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser

        let shiftStore = ShiftStore(shiftService: MockShiftService(error: FirestoreError.unknown))
        let vm = DutyScheduleViewModel(shiftStore: shiftStore, userStore: userStore)

        await vm.fetchShifts()

        #expect(shiftStore.shifts.isEmpty)
        #expect(!vm.hasLoaded)
    }
    
    /// Unit test for at vagterne ikke hentes og fejler fordi brugeren ikke har en virksomhed.
    @Test("fetchShifts fails when user does not have company")
    func fetchShiftsFailsWhenUserDoesNotHaveCompany() async {
        let shiftStore = ShiftStore(shiftService: MockShiftService())
        let vm = DutyScheduleViewModel(shiftStore: shiftStore, userStore: UserStore(userService: MockUserService()))
        
        await vm.fetchShifts()
        
        #expect(shiftStore.shifts.isEmpty)
        #expect(!vm.hasLoaded)
    }
    
    /// Unit test for at vagterne ikke hentes igen.
    @Test("fetchShifts does not fetch again")
    func fetchShiftsDoesNotFetchAgain() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser
        
        let service = MockShiftService()
        let vm = DutyScheduleViewModel(shiftStore: ShiftStore(shiftService: service), userStore: userStore)
        
        await vm.fetchShifts()
        await vm.fetchShifts()
        
        #expect(service.fetchCount == 1)
    }
    
    /// Unit test for at refresh henter vagterne igen.
    @Test("refresh fetches shifts again")
    func refreshFetchesShiftsAgain() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser
        
        let service = MockShiftService()
        let vm = DutyScheduleViewModel(shiftStore: ShiftStore(shiftService: service), userStore: userStore)
        
        await vm.fetchShifts()
        await vm.refresh()
        
        #expect(service.fetchCount == 2)
    }
}
