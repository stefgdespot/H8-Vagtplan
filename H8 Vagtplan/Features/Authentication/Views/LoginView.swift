import SwiftUI

struct LoginView: View {
    @State private var loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(spacing: 16) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Text("Log ind")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                
                Section("Email") {
                    TextField("Skriv din email", text: $loginViewModel.email)
                }
                
                Section("Adgangskode") {
                    TextField("Skriv din adgangskode", text: $loginViewModel.password)
                }
                
                Button {

                } label: {
                    Text("Log ind")
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 50)
                .font(.headline)
                .background(.main, in: .capsule)
                .foregroundStyle(.white)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                
                HStack(spacing: 4) {
                    Text("Har du ikke en konto?")

                    Text("Opret konto")
                        .foregroundStyle(.main)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color.clear)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview {
    LoginView()
}
