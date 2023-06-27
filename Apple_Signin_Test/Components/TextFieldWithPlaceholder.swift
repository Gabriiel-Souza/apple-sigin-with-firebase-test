//
//  TextFieldWithPlaceholder.swift
//  Apple_Signin_Test
//
//  Created by Gabriel Souza de Araujo on 26/06/23.
//

import SwiftUI

struct TextFieldWithPlaceholder: View {
    var isSecure = false
    var title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .opacity(text.isEmpty ? 0 : 1)
                .animation(.easeIn(duration: 0.1), value: text)
            if isSecure {
                SecureField(title, text: $text)
                    .textFieldStyle(.plain)
                    .frame(width: 340)
                    .padding(.horizontal, 5)
            } else {
                TextField(title, text: $text)
                    .textFieldStyle(.plain)
                    .keyboardType(.emailAddress)
                    .frame(width: 340)
                    .padding(.horizontal, 5)
            }
            Rectangle()
                .frame(width: 350, height: 1)
        }
    }
}

struct TextFieldWithPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithPlaceholder(title: "Placeholder", text: .constant(""))
    }
}
