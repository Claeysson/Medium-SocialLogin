import SwiftUI

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
    
    
    @Published var state: AuthState = .signedOut
    
    private var currentAppleNonce: String = ""
    
    var googleAuthConfig: GIDConfiguration
    
    enum SignInProvier {
        case google
        case apple
        case facebook
        case twitter
    }
    
    enum AuthState {
        case signedOut
        case signedIn
    }
    
    override init() {
        // Setup Google signin
        googleAuthConfig = GIDConfiguration.init(clientID: "489616894154-scpen033ci1gjn2hbfikpmmnegr5kdap.apps.googleusercontent.com")
        
        super.init()
        
        let userHandler = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.state = .signedIn
                swiftLog.debug("User Signed In")
            } else {
                self.state = .signedOut
                swiftLog.debug("User Not Signed In")

            }
        }
    }
    
    
    func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        
        request.requestedScopes = [.fullName, .email]
        
        currentAppleNonce = randomNonceString()
        
        request.nonce = sha256(currentAppleNonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.presentationContextProvider = self
        controller.delegate = self
        controller.performRequests()
    }
    
    func signInWithFacebook() {
        guard let viewController = UIApplication.shared.windows.first?.rootViewController else {return}
        
        let loginManager = LoginManager()
        let readPermissions: [Permission] = [ .publicProfile, .email ]

        
        loginManager.logIn(permissions: readPermissions, viewController: viewController) { loginResult in
            switch loginResult {
            case .cancelled:
                print("Sign In Canceled")
            case .failed(let error):
                print("Sign In Error: \(error.localizedDescription)")
            case .success(granted: _, declined: _, token: let token):
                print("Login Success")
                guard let token = token else {return}
                self.firebaseAuthentication(withFacebookToken: token)
            }
        }
        
    }
    
    func signInWithGoogle() {
        swiftLog.debug("Sign In With Google")
        
        guard GIDSignIn.sharedInstance.currentUser == nil else {return}
        
        guard let viewController = UIApplication.shared.windows.first?.rootViewController else {return}
        
        GIDSignIn.sharedInstance.signIn(with: googleAuthConfig, presenting: viewController) { user, error in
            
            guard error == nil else {
                swiftLog.error("Google signin failed")
                swiftLog.error(error?.localizedDescription)
                return
            }
            
            swiftLog.debug("Google signin success")
            
            self.firebaseAuthentication(withGoogleUser: user!)
            
        }
    }
    
    func signOut() {
        
        GIDSignIn.sharedInstance.signOut()
        
        do {
            try Auth.auth().signOut()
            
            state = .signedOut
        } catch let signOutError as NSError {
            swiftLog.error(signOutError.localizedDescription)
        }
    }
    
    func signIn() {
        
        
    }
    
    func firebaseAuthentication(withFacebookToken token: AccessToken) {
        
        swiftLog.debug("Firebase authentication")
        
        let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)

        
        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                swiftLog.error(error.localizedDescription)
            } else {
                swiftLog.debug("Firebase authentication success")
            }
        }
    }
    
    func firebaseAuthentication(withGoogleUser user: GIDGoogleUser) {
        
        swiftLog.debug("Firebase authentication")
        
        let authentication = user.authentication
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                swiftLog.error(error.localizedDescription)
            } else {
                swiftLog.debug("Firebase authentication success")
            }
        }
    }
    
    func firebaseAuthentication(withAppleCredential credential: ASAuthorizationAppleIDCredential) {
        
        swiftLog.debug("Firebase authentication")
        

        guard let appleIDToken = credential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: currentAppleNonce)
        
        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                swiftLog.error(error.localizedDescription)
            } else {
                swiftLog.debug("Firebase authentication success")
            }
        }
    }
    
}
