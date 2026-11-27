import SwiftUI

struct MainTabView: View {
    @Environment(SessionStore.self) private var sessionStore
    
    @State private var companyStore: CompanyStore
    @State private var employeeStore: EmployeeStore
    @State private var mainTabViewModel: MainTabViewModel
    
    private let userStore: UserStore
    
    init(userStore: UserStore, companyService: CompanyServiceProtocol = CompanyService()) {
        let companyStore = CompanyStore(companyService: companyService)
        let employeeStore = EmployeeStore()
        _companyStore = State(initialValue: companyStore)
        _employeeStore = State(initialValue: employeeStore)
        _mainTabViewModel = State(initialValue: MainTabViewModel(companyStore: companyStore, employeeStore: employeeStore, userStore: userStore))
        self.userStore = userStore
    }
    
    var body: some View {
        TabView(selection: $mainTabViewModel.selectedTab) {
            if userStore.currentUser?.role == .owner {
                Tab("Vagtplan", systemImage: "calendar", value: .dutySchedule) {
                    NavigationStack {
                        DutyScheduleView(userStore: userStore)
                    }
                }
                
                Tab("Medarbejdere", systemImage: "person.2", value: .employeeList) {
                    NavigationStack {
                        EmployeeListView(userStore: userStore, employeeStore: employeeStore)
                    }
                }
            }
            
            if userStore.currentUser?.role == .employee {
                Tab("Mine vagter", systemImage: "calendar", value: .myShifts) {
                    NavigationStack {
                        MyShiftsView(userStore: userStore)
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
        .environment(companyStore)
        .environment(employeeStore)
        .onAppear {
            mainTabViewModel.selectedTab = userStore.currentUser?.role == .employee ? .myShifts : .dutySchedule
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
