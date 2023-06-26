//
//  AppleCredentialDisplayName.swift
//  Apple_Signin_Test
//
//  Created by Gabriel Souza de Araujo on 26/06/23.
//

import AuthenticationServices

extension ASAuthorizationAppleIDCredential {
    func displayName() -> String {
        let givenName = fullName?.givenName ?? ""
        let lastName = fullName?.familyName ?? ""
        
        let completeName = givenName + " " + lastName
        
        return completeName
    }
}
