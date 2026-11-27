import SwiftUI

struct DutyScheduleRow: View {
    @Environment(EmployeeStore.self) private var employeeStore
    
    let shift: Shift
    
    var body: some View {
        NavigationLink(value: DutyScheduleRoute.editShift) {
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

#Preview {
    let employeeStore = EmployeeStore(employeeService: MockEmployeeService())
    employeeStore.loadingState = .loaded([.mockEmployeeUser])
    employeeStore.employees = [.mockEmployeeUser]
    
    return DutyScheduleRow(shift: .mockShift)
        .environment(employeeStore)
}
