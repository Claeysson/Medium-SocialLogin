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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
