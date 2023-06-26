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
    @StateObject private var viewModel: SignInViewModel
    
    init(viewModel: SignInViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            
            SignInWithAppleButton { request in
                viewModel.requestSignIn(with: request)
            } onCompletion: { result in
                viewModel.didCompleteSignin(with: result)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: 50)
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.isErrorAlertPresented) {}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
