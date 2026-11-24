import Foundation

@MainActor
@Observable
final class ContentViewModel {
    enum AlertType: Identifiable, Hashable {
        case error(String)
        
        var id: Self { self }
    }
    
    private let sessionStore: SessionStore
    
    var alert: AlertType?
    
    init(sessionStore: SessionStore) {
        self.sessionStore = sessionStore
    }
    
    func loadSession() async {
        do {
            try await sessionStore.loadSession()
        } catch {
            alert = .error(error.localizedDescription)
        }
    }
}
