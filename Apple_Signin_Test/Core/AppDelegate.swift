//
//  AppDelegate.swift
//  Apple_Signin_Test
//
//  Created by Gabriel Souza de Araujo on 25/06/23.
//

import Firebase
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Auth.auth().useEmulator(withHost: "127.0.0.1", port: 9099)
        return true
    }
}
