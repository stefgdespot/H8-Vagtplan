import SwiftUI

struct DutyScheduleView: View {
    @Environment(UserStore.self) private var userStore

    var body: some View {
        Group {
            Text("DutyScheduleView")
        }
        .navigationTitle("Vagtplan")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: DutyScheduleRoute.createShift) {
                    Image(systemName: "plus")
                }
                .foregroundStyle(.primary)
            }
        }
        .navigationDestination(for: DutyScheduleRoute.self) { route in
            switch route {
            case .createShift:
                CreateShiftView(userStore: userStore)
                    .toolbar(.hidden, for: .tabBar)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DutyScheduleView()
    }
    .environment(UserStore(userService: MockUserService()))
    .environment(EmployeeStore(employeeService: MockEmployeeService()))
}
