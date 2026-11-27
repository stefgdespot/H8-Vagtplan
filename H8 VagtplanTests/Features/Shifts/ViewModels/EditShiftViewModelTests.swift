import Testing
import Foundation
@testable import H8_Vagtplan

@MainActor
struct EditShiftViewModelTests {

    @Test("editShift succeeds when assignment is employee and employee is selected")
    func editShiftSucceedsWhenAssignmentIsEmployeeAndEmployeeIsSelected() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser
        
        let shiftService = MockShiftService()
        let shift = Shift.mockShift
        let vm = EditShiftViewModel(shift: shift, userStore: userStore, shiftStore: ShiftStore(shiftService: shiftService), shiftService: shiftService)
        
        let success = await vm.editShift(shift: shift)
        
        #expect(success)
        #expect(vm.alert == nil)
        #expect(shiftService.shift?.employeeId == "employeeId")
        #expect(shiftService.shift?.status == .assigned)
    }
    
    @Test("editShift succeeds when assignment is available")
    func editShiftSucceedsWhenAssignmentIsAvailable() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser
        
        let shiftService = MockShiftService()
        
        var shift = Shift.mockShift
        shift.status = .available
        
        let vm = EditShiftViewModel(shift: shift, userStore: userStore, shiftStore: ShiftStore(shiftService: shiftService), shiftService: shiftService)
        
        let success = await vm.editShift(shift: shift)
        
        #expect(success)
        #expect(vm.alert == nil)
        #expect(shiftService.shift?.employeeId == nil)
        #expect(shiftService.shift?.status == .available)
    }
    
    @Test("editShift fails when saving shift fails.")
    func editShiftFailsWhenSavingShiftFails() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser
        
        let error = FirestoreError.unknown
        let shiftService = MockShiftService(error: error)
        
        let shift = Shift.mockShift
        
        let vm = EditShiftViewModel(shift: shift, userStore: userStore, shiftStore: ShiftStore(shiftService: shiftService), shiftService: shiftService)
        
        let success = await vm.editShift(shift: shift)
        
        #expect(!success)
        #expect(vm.alert == .error(error.localizedDescription))
        #expect(shiftService.shift == nil)
    }
}
