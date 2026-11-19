import SwiftUI
import FirebaseCore

@main struct MyApp: App {
    /// Forbinder appen til Firebase og henter det gemte login fra Keychain.
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
