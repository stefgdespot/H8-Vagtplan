import SwiftUI

struct MainTabView: View {
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
                        Text("Medarbejdere")
                    }
                }
            }
            
            if userStore.currentUser?.role == .employee {
                Tab("Mine vagter", systemImage: "calendar", value: .myShifts) {
                    NavigationStack {
                        Text("Mine vagter")
                    }
                }
                
                Tab("Ledige vagter", systemImage: "calendar.badge.clock", value: .availableShits) {
                    NavigationStack {
                        Text("Ledige vagter")
                    }
                }
            }
            
            Tab("Profil", systemImage: "person.crop.circle", value: .profile) {
                NavigationStack {
                    Text("Profil")
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
        .environment(userStore)
}

#Preview("Employee") {
    let userStore = UserStore(userService: MockUserService())
    userStore.currentUser = .mockEmployeeUser
    
    return MainTabView()
        .environment(userStore)
}
