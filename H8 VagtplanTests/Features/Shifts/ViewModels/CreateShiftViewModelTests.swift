import Testing
@testable import H8_Vagtplan

@MainActor
struct CreateShiftViewModelTests {

    /// Unit test for at vagten oprettes når en medarbejder er valgt.
    @Test("createShift succeeds when employee is selected")
    func createShiftSucceedsWhenEmployeeIsSelected() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser

        let service = MockShiftService()
        let vm = CreateShiftViewModel(userStore: userStore, shiftService: service)
        vm.employeeId = "employeeId"

        let success = await vm.createShift()

        #expect(success)
        #expect(vm.alert == nil)
        #expect(service.shift?.employeeId == "employeeId")
        #expect(service.shift?.status == .assigned)
    }
}
