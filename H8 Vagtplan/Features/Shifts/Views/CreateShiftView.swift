import SwiftUI

struct CreateShiftView: View {
    @State private var createShiftViewModel: CreateShiftViewModel
    
    init(userStore: UserStore, shiftService: ShiftServiceProtocol = ShiftService()) {
        _createShiftViewModel = State(initialValue: CreateShiftViewModel(userStore: userStore, shiftService: shiftService))
    }
    
    var body: some View {
        Form {
            Section("Tidspunkt") {
                DatePicker("Dato", selection: $createShiftViewModel.date, displayedComponents: .date)
                DatePicker("Starttid", selection: $createShiftViewModel.startTime, displayedComponents: .hourAndMinute)
                DatePicker("Sluttid", selection: $createShiftViewModel.endTime, displayedComponents: .hourAndMinute)
            }
            .tint(.main)
            
            Section("Hvem skal have vagten") {
                Picker("", selection: $createShiftViewModel.assignment) {
                    Text("Medarbejder")
                        .tag(ShiftAssignment.employee)
                    
                    Text("Ledig vagt")
                        .tag(ShiftAssignment.available)
                } 
                .pickerStyle(.segmented)
                .labelsHidden()

                if createShiftViewModel.assignment == .employee {
                    Picker("Medarbejder", selection: $createShiftViewModel.employee) {
                        ForEach(0 ... 5, id: \.self) { i in
                            Text("John Doe")
                                .tag(i)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
            }
            
            Button {
                Task {
                    await createShiftViewModel.createShift()
                }
            } label: {
                Text("Opret vagt")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 50)
                    .font(.headline)
                    .background(.main, in: .capsule)
                    .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Opret vagt")
        .navigationBarTitleDisplayMode(.large)
        .alert(item: $createShiftViewModel.alert) { alert in
            switch alert {
            case .error(let message):
                Alert(title: Text("Fejl"), message: Text(message))
            }
        }
    }
}

#Preview("Success") {
    let userStore = UserStore(userService: MockUserService())
    userStore.currentUser = .mockOwnerUser

    return NavigationStack {
        CreateShiftView(userStore: userStore, shiftService: MockShiftService())
    }
}

#Preview("Error") {
    let userStore = UserStore(userService: MockUserService())
    userStore.currentUser = .mockOwnerUser

    return NavigationStack {
        CreateShiftView(userStore: userStore, shiftService: MockShiftService(error: FirestoreError.unknown))
    }
}
