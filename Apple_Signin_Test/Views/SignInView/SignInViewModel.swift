//
//  SignInViewModel.swift
//  Apple_Signin_Test
//
//  Created by Gabriel Souza de Araujo on 26/06/23.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import CryptoKit

class SignInViewModel: ObservableObject {
    @Published var errorMessage = "" {
        didSet {
            isErrorAlertPresented = true
        }
    }
    
    @Published var isErrorAlertPresented = false
    private var currentNonce = ""
    @Published var email = ""
    @Published var password = ""
    
    // MARK: - Apple Handler Functions
    func requestAppleSignIn(with request: ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        request.nonce = sha256(nonce)
        request.requestedScopes = [.fullName]
    }
    
    func didCompleteAppleSignin(with result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let success):
            guard let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential else {
                print("Error on get Apple ID credentials, try again...")
                return
            }
            
            guard
                let appleIDToken = appleIDCredential.identityToken,
                let idTokenString = String(data: appleIDToken, encoding: .utf8)
            else {
                print("Error on get identity token")
                return
            }
            
            let nonce = currentNonce
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            Task {
                do {
                    let result = try await Auth.auth().signIn(with: credential)
                    await updateDisplayName(for: result.user, with: appleIDCredential)
                } catch {
                    
                }
            }
            
            
        case .failure(let failure):
            if !failure.localizedDescription.contains("error 1001") {
                errorMessage = failure.localizedDescription
            }
        }
    }
    
    private func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential) async {
        if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
            // User has a name, don't need to overwrite it
        } else {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = appleIDCredential.displayName()
            
            do {
                try await changeRequest.commitChanges()
            } catch {
                print("Unable to update user display name")
                errorMessage = error.localizedDescription
            }
        }
        
        DispatchQueue.main.async {
            AppUser.shared.updateUser(with: user)
        }
    }
    
    // MARK: - Email/Password Functions
    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard error == nil else {
                self?.errorMessage = error?.localizedDescription ?? ""
                return
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard error == nil else {
                self?.errorMessage = error?.localizedDescription ?? ""
                return
            }
        }
    }
    
    // MARK: - Request Helpers Functions
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}
