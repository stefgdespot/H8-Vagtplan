import SwiftUI

struct DutyScheduleView: View {
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
                        Text("\(shift.startsAt.formatted(date: .omitted, time: .shortened)) - \(shift.endsAt.formatted(date: .omitted, time: .shortened))")
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
}

#Preview("Success") {
    let userStore = UserStore(userService: MockUserService())
    userStore.currentUser = .mockOwnerUser
    
    return NavigationStack {
        DutyScheduleView(userStore: userStore, shiftService: MockShiftService())
    }
}

#Preview("Failed") {
    let userStore = UserStore(userService: MockUserService())
    userStore.currentUser = .mockOwnerUser
    
    return NavigationStack {
        DutyScheduleView(userStore: userStore, shiftService: MockShiftService(error: FirestoreError.unknown))
    }
}
