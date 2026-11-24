import SwiftUI

struct MainTabView: View {
    @Environment(SessionStore.self) private var sessionStore
    @Environment(UserStore.self) private var userStore
    
    @State private var selectedTab: TabItem = .dutySchedule
    
    var body: some View {
        TabView(selection: $selectedTab) {
            if userStore.currentUser?.role == .owner {
                Tab("Vagtplan", systemImage: "calendar", value: .dutySchedule) {
                    NavigationStack {
                        Text("Vagtplan")
                    }
                }
                
                Tab("Medarbejdere", systemImage: "person.2", value: .employeeList) {
                    NavigationStack {
                        EmployeeListView()
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
            selectedTab = userStore.currentUser?.role == .employee ? .myShifts : .dutySchedule
        }
    }
}

#Preview("Owner") {
    let userStore = UserStore(userService: MockUserService())
    userStore.currentUser = .mockOwnerUser
    
    return MainTabView()
        .environment(SessionStore())
        .environment(userStore)
}

#Preview("Employee") {
    let userStore = UserStore(userService: MockUserService())
    userStore.currentUser = .mockEmployeeUser
    
    return MainTabView()
        .environment(SessionStore())
        .environment(userStore)
}
