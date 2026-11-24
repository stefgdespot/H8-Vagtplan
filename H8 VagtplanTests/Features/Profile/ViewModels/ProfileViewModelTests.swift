import Testing
import Foundation
@testable import H8_Vagtplan

@MainActor
struct ProfileViewModelTests {
    /// Unit test for at der ikke vises en alert når man logger ud successfuldt.
    @Test("Logout succeeds without alert")
    func logoutSucceedsWithoutAlert() async {
        let vm = ProfileViewModel(sessionStore: SessionStore(), authService: MockAuthService())
        await vm.logout()
        
        #expect(vm.alert == nil)
    }
    
    /// Unit test for at der vises en alert med fejlbeskeden når log ud fejler.
    @Test("Logout shows alert on error")
    func loginShowsAlertOnError() async {
        let error = AuthError.unknown
        let vm = ProfileViewModel(sessionStore: SessionStore(), authService: MockAuthService(error: error))
        await vm.logout()
        
        #expect(vm.alert == .error(error.localizedDescription))
    }
}
