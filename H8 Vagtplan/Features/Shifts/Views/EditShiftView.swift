import SwiftUI

struct EditShiftView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(EmployeeStore.self) private var employeeStore
    
    @State private var viewModel: EditShiftViewModel
    
    @State private var shift: Shift
    
    init(shift: Shift, userStore: UserStore, shiftService: ShiftServiceProtocol = ShiftService()) {
        _viewModel = State(initialValue: EditShiftViewModel(shift: shift, userStore: userStore, shiftService: shiftService))
        _shift = State(initialValue: shift)
    }
    
    var body: some View {
        Form {
            Section("Tidspunkt") {
                DatePicker("Dato", selection: $shift.startsAt, displayedComponents: .date)
                DatePicker("Starttid", selection: $shift.startsAt, displayedComponents: .hourAndMinute)
                DatePicker("Sluttid", selection: $shift.endsAt, displayedComponents: .hourAndMinute)
            }
            .environment(\.locale, Locale(identifier: "da_DK"))
            .tint(.main)
            .disabled(viewModel.isLoading)
            
            Section("Hvem skal have vagten") {
                Picker("", selection: $viewModel.assignment) {
                    Text("Medarbejder")
                        .tag(ShiftAssignment.employee)
                    
                    Text("Ledig vagt")
                        .tag(ShiftAssignment.available)
                }
                .pickerStyle(.segmented)
                .labelsHidden()

                if viewModel.assignment == .employee {
                    switch employeeStore.loadingState {
                    case .loading:
                        ProgressView()
                    case .failed(let message):
                        Text(message)
                            .foregroundStyle(.secondary)
                    case .loaded:
                        if employeeStore.employees.isEmpty {
                            Text("Der er ingen medarbejdere")
                                .foregroundStyle(.secondary)
                        } else {
                            Picker("Medarbejder", selection: $shift.employeeId) {
                                ForEach(employeeStore.employees) { user in
                                    Text(user.name)
                                        .tag(user.id)
                                }
                            }
                            .pickerStyle(.navigationLink)
                            .tint(.main)
                        }
                    }
                }
            }
            .disabled(viewModel.isLoading)
            
            Button {
                Task {
                    if await viewModel.editShift(shift: shift) {
                        dismiss()
                    }
                }
            } label: {
                Group {
                    if viewModel.isLoading {
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
            .disabled(viewModel.isLoading)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
        .scrollBounceBehavior(.basedOnSize)
        .navigationTitle("Rediger vagt")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(viewModel.isLoading)
        .alert(item: $viewModel.alert) { alert in
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
    employeeStore.loadingState = .loaded

    return NavigationStack {
        EditShiftView(shift: .mockShift, userStore: userStore, shiftService: MockShiftService())
    }
    .environment(employeeStore)
}

#Preview("Error") {
    let userStore = UserStore(userService: MockUserService())
    userStore.currentUser = .mockOwnerUser

    let employeeStore = EmployeeStore(employeeService: MockEmployeeService())
    employeeStore.loadingState = .failed("Du har ikke adgang.")

    return NavigationStack {
        EditShiftView(shift: .mockShift, userStore: userStore, shiftService: MockShiftService(error: FirestoreError.unknown))
    }
    .environment(employeeStore)
}
