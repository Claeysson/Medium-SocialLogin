//
//  Authentication.swift
//  Ease
//
//  Created by Martin Claesson on 2021-07-31.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import CryptoKit
import FacebookCore
import FacebookLogin

class AuthenticationObject: NSObject, ObservableObject {
    
    /// Variable that holds the current sign in/out state
    @Published var state: AuthState = .signedOut
    
    enum AuthState {
        case signedOut
        case signedIn
    }
    
    override init() {
        
        super.init()
        
        
        /// Closure that is called when Firebase auth state chnages. We use it to update our state variable.
        let userHandler = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.state = .signedIn
                print("User signed in")
            } else {
                self.state = .signedOut
                print("User not signed in")

            }
        }
    }
    
    func signInWithApple() {
        print("Sign In With Apple")
    }
    
    func signInWithFacebook() {
        print("Sign In With Facebook")
    }
    
    func signInWithGoogle() {
        print("Sign In With Google")
    }
    
    /// Function that signs out the current user from Firebase
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print(signOutError.localizedDescription)
        }
    }
    
    /// Function that signs in the user with the credentials recived from the sign in provider.
    func signIn(credential: AuthCredential) {
        
        print("Firebase authentication")
        
        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                print("Firebase authentication failed")
                print(error.localizedDescription)
            } else {
                print("Firebase authentication success")
            }
        }
        
        
    }
    
    
}
