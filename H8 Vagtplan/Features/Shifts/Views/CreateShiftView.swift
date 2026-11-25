import SwiftUI

struct CreateShiftView: View {
    @State private var createShiftViewModel = CreateShiftViewModel()
    
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
                        .tag(ShiftAssignment.open)
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
    }
}

#Preview {
    NavigationStack {
        CreateShiftView()
    }
}
