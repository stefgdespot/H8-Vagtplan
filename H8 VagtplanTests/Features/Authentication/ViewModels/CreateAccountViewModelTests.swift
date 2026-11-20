import Testing
import Foundation
@testable import H8_Vagtplan

@MainActor
struct CreateAccountViewModelTests {
    
    /// Unit test for at formen er gyldig når alle felter er udfyldt.
    @Test("Form is valid when all fields are filled")
    func formIsValidWhenAllFieldsAreFilled() {
        let vm = CreateAccountViewModel(sessionStore: SessionStore(), authService: MockAuthService())
        vm.name = "John Doe"
        vm.email = "johndoe@gmail.com"
        vm.password = "123456"
        
        #expect(vm.isFormValid)
    }
    
    /// Unit test for at formen er ugyldig når navnet er tomt.
    @Test("Form is invalid when name is empty")
    func formIsInvalidWhenNameIsEmpty() {
        let vm = CreateAccountViewModel(sessionStore: SessionStore(), authService: MockAuthService())
        vm.name = ""
        vm.email = "johndoe@gmail.com"
        vm.password = "123456"
        
        #expect(!vm.isFormValid)
    }
    
    /// Unit test for at formen er ugyldig når emailen er tom.
    @Test("Form is invalid when email is empty")
    func formIsInvalidWhenEmailIsEmpty() {
        let vm = CreateAccountViewModel(sessionStore: SessionStore(), authService: MockAuthService())
        vm.name = "John Doe"
        vm.email = ""
        vm.password = "123456"
        
        #expect(!vm.isFormValid)
    }
    
    /// Unit test for at formen er ugyldig når adgangskoden er tom.
    @Test("Form is invalid when password is empty")
    func formIsInvalidWhenPasswordIsEmpty() {
        let vm = CreateAccountViewModel(sessionStore: SessionStore(), authService: MockAuthService())
        vm.name = "John Doe"
        vm.email = "johndoe@gmail.com"
        vm.password = ""
        
        #expect(!vm.isFormValid)
    }
    
    /// Unit test for at der ikke vises en alert når kontoen oprettes.
    @Test("Create account succeeds without alert")
    func createAccountSucceedsWithoutAlert() async {
        let vm = CreateAccountViewModel(sessionStore: SessionStore(), authService: MockAuthService())
        vm.name = "John Doe"
        vm.email = "johndoe@gmail.com"
        vm.password = "123456"
        
        await vm.createAccount()
        
        #expect(vm.alert == nil)
    }
    
    /// Unit test for at der vises en alert med fejlbeskeden når oprettelsen fejler.
    @Test("Create account shows alert on error")
    func createAccountShowsAlertOnError() async {
        let error = AuthError.invalidEmail
        let vm = CreateAccountViewModel(sessionStore: SessionStore(), authService: MockAuthService(error: error))
        vm.name = "John Doe"
        vm.email = "johndoe@gmail.com"
        vm.password = "123456"
        
        await vm.createAccount()
        
        #expect(vm.alert == .error(error.localizedDescription))
    }
    
    /// Unit test for at loading stopper igen når oprettelsen fejler.
    @Test("Loading stops after create account fails")
    func isLoadingIsFalseAfterCreateAccountFails() async {
        let vm = CreateAccountViewModel(sessionStore: SessionStore(), authService: MockAuthService(error: AuthError.invalidEmail))
        vm.name = "John Doe"
        vm.email = "johndoe@gmail.com"
        vm.password = "123456"
        
        await vm.createAccount()
        
        #expect(!vm.isLoading)
    }
}
