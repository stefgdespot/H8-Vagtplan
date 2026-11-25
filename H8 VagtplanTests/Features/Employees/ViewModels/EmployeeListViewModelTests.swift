import Testing
@testable import H8_Vagtplan

@MainActor
struct EmployeeListViewModelTests {

    /// Unit test for at medarbejdere hentes når det lykkes.
    @Test("fetchEmployees loads employees on success")
    func fetchEmployeesLoadsEmployeesOnSuccess() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser
        
        let vm = EmployeeListViewModel(userStore: userStore, employeeService: MockEmployeeService())
        
        await vm.fetchEmployees()
        
        #expect(vm.employees.count == 1)
    }
    
    /// Unit test for at der vises en fejl når medarbejdere ikke kan hentes.
    @Test("fetchEmployees shows failed state on error")
    func fetchEmployeesShowsFailedStateOnError() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser
        
        let error = FirestoreError.unknown
        let vm = EmployeeListViewModel(userStore: userStore, employeeService: MockEmployeeService(error: error))
        
        await vm.fetchEmployees()
        
        #expect(vm.employees.isEmpty)
        
        let isFailed = if case .failed = vm.loadingState { true } else { false }
        #expect(isFailed)
    }
    
    /// Unit test for at det fejler når brugeren ikke har en virksomhed.
    @Test("fetchEmployees fails when user has no company")
    func fetchEmployeesFailsWhenUserHasNoCompany() async {
        let vm = EmployeeListViewModel(userStore: UserStore(userService: MockUserService()), employeeService: MockEmployeeService())

        await vm.fetchEmployees()

        #expect(vm.employees.isEmpty)

        let isFailed = if case .failed = vm.loadingState { true } else { false }
        #expect(isFailed)
    }

    /// Unit test for at medarbejdere ikke hentes igen, når de allerede er hentet.
    @Test("fetchEmployees does not fetch again when already loaded")
    func fetchEmployeesDoesNotFetchAgainWhenAlreadyLoaded() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser

        let service = MockEmployeeService()
        let vm = EmployeeListViewModel(userStore: userStore, employeeService: service)

        await vm.fetchEmployees()
        await vm.fetchEmployees()

        #expect(service.fetchCount == 1)
        #expect(vm.employees.count == 1)
    }

    /// Unit test for at refresh henter medarbejdere igen.
    @Test("refresh fetches employees again")
    func refreshFetchesEmployeesAgain() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockOwnerUser

        let service = MockEmployeeService()
        let vm = EmployeeListViewModel(userStore: userStore, employeeService: service)

        await vm.fetchEmployees()
        await vm.refresh()

        #expect(service.fetchCount == 2)
        #expect(vm.employees.count == 1)
    }
}
