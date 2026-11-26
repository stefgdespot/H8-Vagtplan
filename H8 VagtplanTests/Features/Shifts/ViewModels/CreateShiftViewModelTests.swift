import Testing
import Foundation
@testable import H8_Vagtplan

@MainActor
struct CreateShiftViewModelTests {

    /// Unit test for at vagten oprettes når assignment er medarbejder og en medarbejder er valgt.
    @Test("createShift succeeds when assignment is employee and employee is selected")
    func createShiftSucceedsWhenAssignmentIsEmployeeAndEmployeeIsSelected() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser

        let service = MockShiftService()
        let vm = CreateShiftViewModel(userStore: userStore, shiftService: service)
        vm.assignment = .employee
        vm.employeeId = "employeeId"

        let success = await vm.createShift()

        #expect(success)
        #expect(vm.alert == nil)
        #expect(service.shift?.employeeId == "employeeId")
        #expect(service.shift?.status == .assigned)
    }

    /// Unit test for at kaldet fejler når assignment er medarbejder og ingen medarbejder er valgt.
    @Test("createShift fails when assignment is employee and employee is missing")
    func createShiftFailsWhenAssignmentIsEmployeeAndEmployeeIsMissing() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser

        let service = MockShiftService()
        let vm = CreateShiftViewModel(userStore: userStore, shiftService: service)
        vm.assignment = .employee

        let success = await vm.createShift()

        #expect(!success)
        #expect(vm.alert == .missingEmployee)
        #expect(service.shift == nil)
    }

    /// Unit test for at kaldet fejler når brugeren ikke har en virksomhed.
    @Test("createShift fails when user has no company")
    func createShiftFailsWhenUserHasNoCompany() async {
        let service = MockShiftService()
        let vm = CreateShiftViewModel(userStore: UserStore(userService: MockUserService()), shiftService: service)
        vm.assignment = .employee
        vm.employeeId = "employeeId"

        let success = await vm.createShift()

        #expect(!success)
        #expect(vm.alert == .error("Du er ikke tilmeldt en virksomhed."))
        #expect(service.shift == nil)
    }

    /// Unit test for at en ledig vagt oprettes uden medarbejder.
    @Test("createShift succeeds when assignment is available")
    func createShiftSucceedsWhenAssignmentIsAvailable() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser

        let service = MockShiftService()
        let vm = CreateShiftViewModel(userStore: userStore, shiftService: service)
        vm.assignment = .available

        let success = await vm.createShift()

        #expect(success)
        #expect(vm.alert == nil)
        #expect(service.shift?.employeeId == nil)
        #expect(service.shift?.status == .available)
    }

    /// Unit test for at kaldet fejler når vagten ikke kan gemmes.
    @Test("createShift fails when saving the shift fails")
    func createShiftFailsWhenSavingTheShiftFails() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser

        let error = FirestoreError.unknown
        let service = MockShiftService(error: error)
        let vm = CreateShiftViewModel(userStore: userStore, shiftService: service)
        vm.assignment = .employee
        vm.employeeId = "employeeId"

        let success = await vm.createShift()

        #expect(!success)
        #expect(vm.alert == .error(error.localizedDescription))
        #expect(service.shift == nil)
    }
}
