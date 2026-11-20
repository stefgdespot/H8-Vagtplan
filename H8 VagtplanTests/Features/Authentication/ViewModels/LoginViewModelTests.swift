import Testing
import Foundation
@testable import H8_Vagtplan

@MainActor
struct LoginViewModelTests {

    /// Unit test for at formen er gyldig når alle felter er udfyldt.
    @Test("Form is valid when all fields are filled")
    func formIsValidWhenAllFieldsAreFilled() {
        let vm = LoginViewModel(sessionStore: SessionStore(), authService: MockAuthService())
        vm.email = "johndoe@gmail.com"
        vm.password = "123456"
        
        #expect(vm.isFormValid)
    }
    
    /// Unit test for at formen er ugyldig når emailen er tom.
    @Test("Form is invalid when email is empty")
    func formIsInvalidWhenEmailIsEmpty() {
        let vm = LoginViewModel(sessionStore: SessionStore(), authService: MockAuthService())
        vm.email = ""
        vm.password = "123456"
        
        #expect(!vm.isFormValid)
    }
    
    /// Unit test for at formen er ugyldig når adgangskoden er tom.
    @Test("Form is invalid when password is empty")
    func formIsInvalidWhenPasswordIsEmpty() {
        let vm = LoginViewModel(sessionStore: SessionStore(), authService: MockAuthService())
        vm.email = "johndoe@gmail.com"
        vm.password = ""
        
        #expect(!vm.isFormValid)
    }
    
    /// Unit test for at der ikke vises en alert når man logger ind successfuldt.
    @Test("Login succeeds without alert")
    func loginSucceedsWithoutAlert() async {
        let vm = LoginViewModel(sessionStore: SessionStore(), authService: MockAuthService())
        vm.email = "johndoe@gmail.com"
        vm.password = "123456"
        
        await vm.login()
        
        #expect(vm.alert == nil)
    }
    
    /// Unit test for at der vises en alert med fejlbeskeden når login fejler.
    @Test("Login shows alert on error")
    func loginShowsAlertOnError() async {
        let error = AuthError.invalidEmail
        let vm = LoginViewModel(sessionStore: SessionStore(), authService: MockAuthService(error: error))
        vm.email = "johndoe@gmail.com"
        vm.password = "123456"
        
        await vm.login()
        
        #expect(vm.alert == .error(error.localizedDescription))
    }
    
    /// Unit test for at loading stopper igen når login fejler.
    @Test("Loading stops after login fails")
    func isLoadingIsFalseAfterLoginFails() async {
        let vm = LoginViewModel(sessionStore: SessionStore(), authService: MockAuthService(error: AuthError.invalidEmail))
        vm.email = "johndoe@gmail.com"
        vm.password = "123456"
        
        await vm.login()
        
        #expect(!vm.isLoading)
    }
}
