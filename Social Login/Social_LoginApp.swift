//
//  Social_LoginApp.swift
//  Social Login
//
//  Created by Martin Claesson on 2021-08-06.
//

import SwiftUI
import Firebase

@main
struct Social_LoginApp: App {
    
    private let authObject: AuthenticationObject
    
    init() {
        FirebaseApp.configure()
        authObject = AuthenticationObject()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authObject)
        }
    }
}
