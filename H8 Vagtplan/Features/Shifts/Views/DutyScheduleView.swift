import SwiftUI

struct DutyScheduleView: View {
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
            }
        }
        .navigationDestination(for: DutyScheduleRoute.self) { route in
            switch route {
            case .createShift:
                CreateShiftView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        DutyScheduleView()
    }
}
