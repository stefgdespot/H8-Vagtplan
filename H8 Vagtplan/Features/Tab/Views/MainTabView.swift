import SwiftUI

struct MainTabView: View {
    @Environment(SessionStore.self) private var sessionStore
    
    @State private var companyStore: CompanyStore
    @State private var mainTabViewModel: MainTabViewModel
    
    private let userStore: UserStore
    
    init(userStore: UserStore, companyService: CompanyServiceProtocol = CompanyService()) {
        let companyStore = CompanyStore(companyService: companyService)
        _companyStore = State(initialValue: companyStore)
        _mainTabViewModel = State(initialValue: MainTabViewModel(companyStore: companyStore, userStore: userStore))
        self.userStore = userStore
    }
    
    var body: some View {
        TabView(selection: $mainTabViewModel.selectedTab) {
            if userStore.currentUser?.role == .owner {
                Tab("Vagtplan", systemImage: "calendar", value: .dutySchedule) {
                    NavigationStack {
                        Text("Vagtplan")
                    }
                }
                
                Tab("Medarbejdere", systemImage: "person.2", value: .employeeList) {
                    NavigationStack {
                        EmployeeListView(userStore: userStore)
                    }
                }
            }
            
            if userStore.currentUser?.role == .employee {
                Tab("Mine vagter", systemImage: "calendar", value: .myShifts) {
                    NavigationStack {
                        Text("Mine vagter")
                    }
                }
                
                Tab("Ledige vagter", systemImage: "calendar.badge.plus", value: .availableShits) {
                    NavigationStack {
                        Text("Ledige vagter")
                    }
                }
            }
            
            Tab("Profil", systemImage: "person.crop.circle", value: .profile) {
                NavigationStack {
                    ProfileView(sessionStore: sessionStore)
                }
            }
        }
        .tint(.main)
        .onAppear {
            mainTabViewModel.selectedTab = userStore.currentUser?.role == .employee ? .myShifts : .dutySchedule
        }
        .task {
            await mainTabViewModel.fetchCompany()
        }
        .alert(item: $mainTabViewModel.alert) { alert in
            switch alert {
            case .error(let message):
                Alert(title: Text("Fejl"), message: Text(message))
            }
        }
    }
}

#Preview("Owner") {
    let userStore = UserStore(userService: MockUserService())
    userStore.currentUser = .mockOwnerUser
    
    return MainTabView(userStore: userStore, companyService: MockCompanyService())
        .environment(SessionStore())
}

#Preview("Employee") {
    let userStore = UserStore(userService: MockUserService())
    userStore.currentUser = .mockEmployeeUser
    
    return MainTabView(userStore: userStore, companyService: MockCompanyService())
        .environment(SessionStore())
}
