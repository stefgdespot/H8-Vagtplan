import SwiftUI

struct MyShiftsView: View {
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
            
            Section("tirsdag den 17. november 2026") {
                HStack {
                    Text("8:45 - 14:00")
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Meld afbud")
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("Mine vagter")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        MyShiftsView()
    }
}
