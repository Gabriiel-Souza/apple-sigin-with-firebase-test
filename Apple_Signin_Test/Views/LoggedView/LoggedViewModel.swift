//
//  LoggedViewModel.swift
//  Apple_Signin_Test
//
//  Created by Gabriel Souza de Araujo on 26/06/23.
//

import Firebase
import SwiftUI

class LoggedViewModel: ObservableObject {
    @Published var errorMessage = ""
    
    func logout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                AppUser.shared.updateUser(with: nil)
            }
        } catch {
            errorMessage = error.localizedDescription
            print(error.localizedDescription)
        }
    }
}
