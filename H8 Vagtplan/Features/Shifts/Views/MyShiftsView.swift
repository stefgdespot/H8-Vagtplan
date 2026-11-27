import SwiftUI

struct MyShiftsView: View {
    @State private var viewModel: MyShiftsViewModel
    
    init(userStore: UserStore, shiftService: ShiftServiceProtocol = ShiftService()) {
        _viewModel = State(initialValue: MyShiftsViewModel(userStore: userStore, shiftService: shiftService))
    }
    
    var body: some View {
        List {
            Section("Næste vagt") {
                VStack(alignment: .leading) {
                    Text("mandag den 16. november 2026")
                        .foregroundStyle(.secondary)
                    
                    Text("8:00 - 14:00")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Button {
                        
                    } label: {
                        Text("Meld afbud")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .font(.headline)
                            .background(.red.opacity(0.2), in: .capsule)
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.plain)
                }
            }
            
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
            case .loaded:
                // Vis kun vagter der ikke er slut
                let upcomingShifts = viewModel.shifts.filter { $0.endsAt > .now }
                
                if upcomingShifts.isEmpty {
                    ContentUnavailableView(
                        "Ingen vagter",
                        systemImage: "calendar",
                        description: Text("Du har ingen vagter endnu.")
                    )
                } else {
                    // Grupper vagterne pr dag
                    let days = Dictionary(grouping: upcomingShifts) { shift in
                        Calendar.current.startOfDay(for: shift.startsAt)
                    }
                    
                    // Vis dagene i rækkefølge
                    ForEach(days.keys.sorted(), id: \.self) { day in
                        Section(day.formatted(.dateTime.weekday(.wide).day().month(.wide).year().locale(Locale(identifier: "da_DK")))) {
                            ForEach(days[day] ?? []) { shift in
                                Text(shift.status.rawValue)
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
            await viewModel.fetchEmployeeShifts()
        }
        .navigationTitle("Mine vagter")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview("Success") {
    let userStore = UserStore(userService: MockUserService())
    userStore.currentUser = .mockEmployeeUser
    
    return NavigationStack {
        MyShiftsView(userStore: userStore, shiftService: MockShiftService())
    }
}

#Preview("Error") {
    let userStore = UserStore(userService: MockUserService())
    userStore.currentUser = .mockEmployeeUser
    
    return NavigationStack {
        MyShiftsView(userStore: userStore, shiftService: MockShiftService(error: FirestoreError.unknown))
    }
}
