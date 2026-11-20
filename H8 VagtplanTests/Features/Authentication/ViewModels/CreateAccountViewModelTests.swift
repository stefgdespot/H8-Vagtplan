import Testing
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
}
