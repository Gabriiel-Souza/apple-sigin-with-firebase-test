//
//  Apple_Signin_TestApp.swift
//  Apple Signin Test
//
//  Created by Gabriel Souza de Araujo on 25/06/23.
//

import SwiftUI
import FirebaseService
import Firebase

@main
struct Apple_Signin_TestApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var currentUser = AppUser.shared
    @State var authStateHandler: AuthStateDidChangeListenerHandle?
    
    var body: some Scene {
        WindowGroup {
                NavigationView {
                    switch AppUser.shared.state {
                    case .undefined:
                        ProgressView()
                            .foregroundColor(.blue)
                            .onAppear {
                                getUser()
                            }
                    case .unauthenticated:
                        SignInView(viewModel: SignInViewModel())
                    case .authenticaded:
                        LoggedView()
                    }
                }
        }
    }
    
    private func getUser() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                AppUser.shared.updateUser(with: user)
            }
        }
    }
}
