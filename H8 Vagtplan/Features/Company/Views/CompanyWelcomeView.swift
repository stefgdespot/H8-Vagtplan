//
//  CompanyWelcomeView.swift
//  H8 Vagtplan
//
//  Created by Stefan Gusatovic on 23/11/2026.
//

import SwiftUI

struct CompanyWelcomeView: View {
    var body: some View {
        NavigationStack {
            List {
                VStack(spacing: 16) {
                    AppLogo()
                    
                    VStack {
                        Text("Log ind")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Hvad vil du gøre?")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                
                Section {
                    NavigationLink(value: CompanyWelcomeRoute.createCompany) {
                        HStack(spacing: 12) {
                            Image(systemName: "building.2")
                                .font(.system(size: 24))
                                .foregroundStyle(.main)
                            
                            VStack(alignment: .leading) {
                                Text("Opret virksomhed")
                                    .font(.headline)
                                    
                                Text("Jeg er chef og vil lægge vagter ud")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
                
                Section {
                    NavigationLink(value: CompanyWelcomeRoute.joinCompany) {
                        HStack(spacing: 12) {
                            Image(systemName: "key")
                                .font(.system(size: 24))
                                .foregroundStyle(.main)
                            
                            VStack(alignment: .leading) {
                                Text("Jeg har en kode")
                                    .font(.headline)
                                    
                                Text("Min chef har givet mig en kode")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .safeAreaInset(edge: .bottom) {
                Button("Log ud") {
                    
                }
                .font(.headline)
                .foregroundStyle(.red)
            }
            .navigationDestination(for: CompanyWelcomeRoute.self) { route in
                switch route {
                case .createCompany:
                    EmptyView()
                case .joinCompany:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    CompanyWelcomeView()
}
