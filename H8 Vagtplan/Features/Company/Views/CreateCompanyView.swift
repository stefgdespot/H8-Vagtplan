import SwiftUI

struct CreateCompanyView: View {
    @State private var createCompanyViewModel = CreateCompanyViewModel()
    
    var body: some View {
        Form {
            VStack(spacing: 16) {
                Image(systemName: "building.2")
                    .font(.system(size: 80))
                    .foregroundStyle(.main)
                
                VStack {
                    Text("Opret virksomhed")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Du bliver chef og får en kode til dine medarbejdere")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(Color.clear)
            
            Section("Virksomhedsnavn") {
                TextField("Skriv dit virksomhedsnavn", text: $createCompanyViewModel.name)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
            }
            
            Button {
                
            } label: {
                Group {
                    if createCompanyViewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Opret virksomhed")
                    }
                }
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
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.immediately)
        .disabled(createCompanyViewModel.isLoading)
        .navigationBarBackButtonHidden(createCompanyViewModel.isLoading)
    }
}

#Preview {
    CreateCompanyView()
}
