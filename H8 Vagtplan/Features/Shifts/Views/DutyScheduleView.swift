import SwiftUI

/// Står for at vise skærmen for Vagtplan (chef).
struct DutyScheduleView: View {
    @Environment(EmployeeStore.self) private var employeeStore
    
    @State private var shiftStore: ShiftStore
    @State private var viewModel: DutyScheduleViewModel
    
    private let userStore: UserStore
    
    init(userStore: UserStore, shiftService: ShiftServiceProtocol = ShiftService()) {
        let shiftStore = ShiftStore(shiftService: shiftService)
        
        _shiftStore = State(initialValue: shiftStore)
        _viewModel = State(initialValue: DutyScheduleViewModel(shiftStore: shiftStore, userStore: userStore))
        self.userStore = userStore
    }

    var body: some View {
        List {
            switch viewModel.loadingState {
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
                    // Grupper vagterne pr dag
                    let days = Dictionary(grouping: shifts) { shift in
                        Calendar.current.startOfDay(for: shift.startsAt)
                    }
                    
                    // Vis dagene i rækkefølge
                    ForEach(days.keys.sorted(), id: \.self) { day in
                        Section(day.formatted(.dateTime.weekday(.wide).day().month(.wide).year().locale(Locale(identifier: "da_DK")))) {
                            ForEach(days[day] ?? []) { shift in
                                DutyScheduleRow(shift: shift)
                            }
                        }
                    }
                }
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.fetchShifts()
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
            case .editShift:
                EmptyView()
            }
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
