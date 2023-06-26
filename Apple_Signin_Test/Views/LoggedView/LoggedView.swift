//
//  LoggedView.swift
//  Apple_Signin_Test
//
//  Created by Gabriel Souza de Araujo on 26/06/23.
//

import SwiftUI

struct LoggedView: View {
    @StateObject private var viewModel = LoggedViewModel()
    
    var body: some View {
        Button("Logout") {
            viewModel.logout()
        }
    }
}

struct LoggedView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedView()
    }
}
