//
//  AppLogo.swift
//  H8 Vagtplan
//
//  Created by Stefan Gusatovic on 23/11/2026.
//

import SwiftUI

struct AppLogo: View {
    var body: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    AppLogo()
}
