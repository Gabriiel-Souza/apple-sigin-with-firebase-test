//
//  SignInView.swift
//  Apple Signin Test
//
//  Created by Gabriel Souza de Araujo on 25/06/23.
//

import SwiftUI
import FirebaseService
import AuthenticationServices

struct SignInView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel: SignInViewModel
    
    init(viewModel: SignInViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 30) {
            
            VStack(spacing: 20) {
                VStack(spacing: 12) {
                    TextFieldWithPlaceholder(title: "Email", text: $viewModel.email)
                    TextFieldWithPlaceholder(isSecure: true, title: "Password", text: $viewModel.password)
                }
                
                HStack {
                    Button("Sign In") {
                        viewModel.login()
                    }
                    
                    Button("Sign Up") {
                        viewModel.registerUser()
                    }
                }
            }
            
            SignInWithAppleButton { request in
                viewModel.requestAppleSignIn(with: request)
            } onCompletion: { result in
                viewModel.didCompleteAppleSignin(with: result)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.isErrorAlertPresented) {}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
