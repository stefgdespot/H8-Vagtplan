import Testing
@testable import H8_Vagtplan

@MainActor
struct EmployeeListViewModelTests {

    /// Unit test for at medarbejdere hentes når det lykkes.
    @Test("refresh loads employees on success")
    func refreshLoadsEmployeesOnSuccess() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser
        
        let employeeStore = EmployeeStore(employeeService: MockEmployeeService())
        let vm = EmployeeListViewModel(userStore: userStore, employeeStore: employeeStore)
        
        await vm.refresh()
        
        #expect(employeeStore.employees.count == 1)
    }
    
    /// Unit test for at der vises en fejl når medarbejdere ikke kan hentes.
    @Test("refresh shows failed state on error")
    func refreshShowsFailedStateOnError() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser
        
        let error = FirestoreError.unknown
        let employeeStore = EmployeeStore(employeeService: MockEmployeeService(error: error))
        let vm = EmployeeListViewModel(userStore: userStore, employeeStore: employeeStore)
        
        await vm.refresh()
        
        #expect(employeeStore.employees.isEmpty)
        
        let isFailed = if case .failed = employeeStore.loadingState { true } else { false }
        #expect(isFailed)
    }
    
    /// Unit test for at det fejler når brugeren ikke har en virksomhed.
    @Test("refresh fails when user has no company")
    func refreshFailsWhenUserHasNoCompany() async {
        let employeeStore = EmployeeStore(employeeService: MockEmployeeService())
        let vm = EmployeeListViewModel(userStore: UserStore(userService: MockUserService()), employeeStore: employeeStore)

        await vm.refresh()

        #expect(employeeStore.employees.isEmpty)

        let isFailed = if case .failed = employeeStore.loadingState { true } else { false }
        #expect(isFailed)
    }

    /// Unit test for at refresh henter medarbejdere igen.
    @Test("refresh fetches employees again")
    func refreshFetchesEmployeesAgain() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser

        let service = MockEmployeeService()
        let employeeStore = EmployeeStore(employeeService: service)
        let vm = EmployeeListViewModel(userStore: userStore, employeeStore: employeeStore)

        await vm.refresh()
        await vm.refresh()

        #expect(service.fetchCount == 2)
        #expect(employeeStore.employees.count == 1)
    }
}
