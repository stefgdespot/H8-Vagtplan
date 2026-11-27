import SwiftUI

struct DutyScheduleView: View {
    @Environment(EmployeeStore.self) private var employeeStore
    
    @State private var shiftStore: ShiftStore
    @State private var dutyScheduleViewModel: DutyScheduleViewModel
    
    private let userStore: UserStore
    
    init(userStore: UserStore, shiftService: ShiftServiceProtocol = ShiftService()) {
        let shiftStore = ShiftStore(shiftService: shiftService)
        
        _shiftStore = State(initialValue: shiftStore)
        _dutyScheduleViewModel = State(initialValue: DutyScheduleViewModel(shiftStore: shiftStore, userStore: userStore))
        self.userStore = userStore
    }

    var body: some View {
        List {
            switch dutyScheduleViewModel.loadingState {
            case .loading:
                ProgressView("Henter vagter...")
                    .frame(maxWidth: .infinity, alignment: .center)
            case .failed(let message):
                ContentUnavailableView(
                    "Fejl",
                    systemImage: "exclamationmark.triangle",
                    description: Text(message)
                )
            case .loaded(let shifts):
                if shifts.isEmpty {
                    ContentUnavailableView(
                        "Ingen vagter",
                        systemImage: "calendar",
                        description: Text("Der er ingen vagter endnu.")
                    )
                } else {
                    ForEach(shifts) { shift in
                        HStack {
                            Text("\(shift.startsAt.formatted(date: .omitted, time: .shortened)) - \(shift.endsAt.formatted(date: .omitted, time: .shortened))")
                            
                            Spacer()
                            
                            switch shift.status {
                            case .assigned:
                                employeeName(shift: shift)
                                    .foregroundStyle(.gray)
                            case .available:
                                Text("Ledig")
                                    .foregroundStyle(.green)
                            case .absent:
                                employeeName(shift: shift)
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
            }
        }
        .task {
            await dutyScheduleViewModel.fetchShifts()
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
    
    @ViewBuilder
    private func employeeName(shift: Shift) -> some View {
        let name = employeeStore.employees.first { $0.id == shift.employeeId }?.name ?? "Ingen medarbejder"
        
        switch employeeStore.loadingState {
        case .loading:
            ProgressView()
        case .failed(let message):
            Text(message)
        case .loaded:
            Text(shift.status == .absent ? "Afbud - \(name)" : name)
        }
    }
}

#Preview("Success") {
    let userStore = UserStore(userService: MockUserService())
    userStore.currentUser = .mockOwnerUser
    let employeeStore = EmployeeStore(employeeService: MockEmployeeService())
    employeeStore.employees = [.mockEmployeeUser]
    employeeStore.loadingState = .loaded([.mockEmployeeUser])
    
    return NavigationStack {
        DutyScheduleView(userStore: userStore, shiftService: MockShiftService())
    }
    .environment(employeeStore)
}

#Preview("Failed") {
    let userStore = UserStore(userService: MockUserService())
    userStore.currentUser = .mockOwnerUser
    
    return NavigationStack {
        DutyScheduleView(userStore: userStore, shiftService: MockShiftService(error: FirestoreError.unknown))
    }
    .environment(EmployeeStore(employeeService: MockEmployeeService(error: FirestoreError.unknown)))
}
