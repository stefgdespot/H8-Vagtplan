//
//  EmployeeListView.swift
//  H8 Vagtplan
//
//  Created by Stefan Gusatovic on 24/11/2026.
//

import SwiftUI

struct EmployeeListView: View {
    var body: some View {
        List {
            Section("Invitationskode") {
                HStack {
                    Text("X7K9Q2")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button("Del kode") {
                        
                    }
                    .buttonStyle(.plain)
                    .font(.headline)
                    .foregroundStyle(.main)
                }
            }
            
            Section("4 medarbejdere") {
                ForEach(0...5, id: \.self) { i in
                    VStack(alignment: .leading) {
                        Text("John Doe")
                            .font(.headline)
                        
                        Text("johndoe@mail.com")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Medarbejdere")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        EmployeeListView()
    }
}
