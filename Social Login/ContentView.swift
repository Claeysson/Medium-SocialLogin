//
//  ContentView.swift
//  Social Login
//
//  Created by Martin Claesson on 2021-08-06.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authObject: AuthenticationObject
    
    var body: some View {
        ZStack{
            Color.init(red: 0.87, green: 0.89, blue: 0.92)
                .edgesIgnoringSafeArea(.all)
        VStack {
            Spacer()
            
            Text("Sign into your account.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            if authObject.state == .signedIn {
                Text("Signed In")
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Sign Out") {
                    authObject.signOut()
                }
            } else {
                Text("Signed Out")
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            Spacer()
            
            if authObject.state == .signedOut {
                SignInButtons()
            }
        }
    }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static let authObject = AuthenticationObject()
    
    static var previews: some View {
        ContentView()
            .environmentObject(authObject)
    }
}
