import Testing
@testable import H8_Vagtplan

@MainActor
struct CreateCompanyViewModelTests {
    @Test("Form is valid when all fields are filled")
    func formIsValidWhenAllFieldsAreFilled() {
        let vm = CreateCompanyViewModel(sessionStore: SessionStore(), userStore: UserStore())
        vm.name = "Fresh Finds"
        
        #expect(vm.isFormValid)
    }
    
    @Test("Form is not valid when name is empty")
    func formIsNotValidWhenNameIsEmpty() {
        let vm = CreateCompanyViewModel(sessionStore: SessionStore(), userStore: UserStore())
        
        #expect(!vm.isFormValid)
    }
    
    @Test("Alert is nil when createCompany is success")
    func alertIsNilWhenCreateCompanyIsSuccess() async {
        let userStore = UserStore(userService: MockUserService())
        userStore.currentUser = .mockUser
        
        let vm = CreateCompanyViewModel(
            sessionStore: SessionStore(),
            userStore: userStore,
            companyService: MockCompanyService()
        )
        
        await vm.createCompany()
        
        #expect(vm.alert == nil)
    }
    
    @Test("Alert shows when createCompany fails")
    func alertShowsWhenCreateCompanyFails() async {
        let vm = CreateCompanyViewModel(
            sessionStore: SessionStore(),
            userStore: UserStore(),
            companyService: MockCompanyService(error: FirestoreError.unknown)
        )
        
        await vm.createCompany()
        
        #expect(vm.alert != nil)
    }
}
