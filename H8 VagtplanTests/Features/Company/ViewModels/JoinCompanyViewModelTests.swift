import Testing
import Foundation
@testable import H8_Vagtplan

@MainActor
struct JoinCompanyViewModelTests {
    @Test("Form is valid when all fields are filled")
    func formIsValidWhenAllFieldsAreFilled() async throws {
        let vm = JoinCompanyViewModel(sessionStore: SessionStore(), userStore: UserStore())
        vm.code = "123456"
        
        #expect(vm.isFormValid)
    }
    
    @Test("Form is not valid when code is empty")
    func formIsNotValidWhenCodeIsEmpty() async throws {
        let vm = JoinCompanyViewModel(sessionStore: SessionStore(), userStore: UserStore())
        
        #expect(!vm.isFormValid)
    }
    
    @Test("Alert is nil when joinCompany is success")
    func alertIsNilWhenJoinCompanyIsSuccess() async {
        let userStore = UserStore(userService: MockUserService())
        
        let vm = JoinCompanyViewModel(
            sessionStore: SessionStore(userStore: userStore),
            userStore: userStore,
            companyService: MockCompanyService()
        )
        
        await vm.joinCompany()
        
        #expect(vm.alert == nil)
    }
    
    @Test("joinCompany shows alert on error")
    func joinCompanyShowsAlertOnError() async {
        let userStore = UserStore(userService: MockUserService())
        
        let error = FirestoreError.unknown
        
        let vm = JoinCompanyViewModel(
            sessionStore: SessionStore(userStore: userStore),
            userStore: userStore,
            companyService: MockCompanyService(error: error)
        )
        
        await vm.joinCompany()
        
        #expect(vm.alert == .error(error.localizedDescription))
    }
}
