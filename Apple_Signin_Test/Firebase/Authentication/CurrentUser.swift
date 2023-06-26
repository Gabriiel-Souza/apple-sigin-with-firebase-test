//
//  CurrentUser.swift
//  Apple_Signin_Test
//
//  Created by Gabriel Souza de Araujo on 26/06/23.
//

import SwiftUI
import Firebase

enum AuthenticationState {
    case undefined, unauthenticated, authenticaded
}

class AppUser: ObservableObject {
    
    public static let shared = AppUser()
    @Published var current: User?
    @Published var state: AuthenticationState = .undefined
    
    private init() {}
    
    func updateUser(with user: User?) {
        current = user
        state = user != nil ? .authenticaded : .unauthenticated
    }
}
