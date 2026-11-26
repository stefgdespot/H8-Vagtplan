import SwiftUI

struct CreateShiftView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(EmployeeStore.self) private var employeeStore
    
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
            .disabled(createShiftViewModel.isLoading)
            
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
                    switch employeeStore.loadingState {
                    case .loading:
                        ProgressView()
                    case .failed(let message):
                        Text(message)
                            .foregroundStyle(.secondary)
                    case .loaded(let users):
                        if users.isEmpty {
                            Text("Der er ingen medarbejdere")
                                .foregroundStyle(.secondary)
                        } else {
                            Picker("Medarbejder", selection: $createShiftViewModel.employeeId) {
                                ForEach(users) { user in
                                    Text(user.name)
                                        .tag(user.id ?? "")
                                }
                            }
                            .pickerStyle(.navigationLink)
                            .tint(.main)
                        }
                    }
                }
            }
            .disabled(createShiftViewModel.isLoading)
            
            Button {
                Task {
                    if await createShiftViewModel.createShift() {
                        dismiss()
                    }
                }
            } label: {
                Group {
                    if createShiftViewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Opret vagt")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 50)
                .font(.headline)
                .background(.main, in: .capsule)
                .foregroundStyle(.white)
            }
            .buttonStyle(.plain)
            .disabled(createShiftViewModel.isLoading)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle("Opret vagt")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(createShiftViewModel.isLoading)
        .alert(item: $createShiftViewModel.alert) { alert in
            switch alert {
            case .error(let message):
                Alert(title: Text("Fejl"), message: Text(message))
            case .missingEmployee:
                Alert(title: Text("Vælg medarbejder"), message: Text("Du skal vælge en medarbejder til vagten."))
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
        CreateShiftView(userStore: userStore, shiftService: MockShiftService())
    }
    .environment(employeeStore)
}

#Preview("Error") {
    let userStore = UserStore(userService: MockUserService())
    userStore.currentUser = .mockOwnerUser

    let employeeStore = EmployeeStore(employeeService: MockEmployeeService())
    employeeStore.loadingState = .failed("Du har ikke adgang.")

    return NavigationStack {
        CreateShiftView(userStore: userStore, shiftService: MockShiftService(error: FirestoreError.unknown))
    }
    .environment(employeeStore)
}
