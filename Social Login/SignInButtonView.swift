//
//  SignInButtonView.swift
//  Social Login
//
//  Created by Martin Claesson on 2021-08-06.
//

import SwiftUI

struct SignInButtons: View {
    
    @EnvironmentObject var authObject: AuthenticationObject
    
    var body: some View {
        VStack(spacing:20){
            Button(action: {authObject.signInWithApple()}) {
                ZStack {
                    HStack(){
                        Image(systemName: "applelogo")
                            .font(.system(size: 25))
                            .frame(width: 30, height: 30)
                        Spacer()
                    }.frame(maxWidth: .infinity)
                    Text("Sign in with Apple")
                        .frame(maxWidth: .infinity)
                }
            }.buttonStyle(AuthenticationButtonStyle(provider: .apple))
            Button(action: {authObject.signInWithGoogle()}) {
                ZStack {
                    HStack{
                        Image("googleSignInLogoAlt")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Spacer()
                    }
                    Text("Sign in with Google")
                }.frame(maxWidth: .infinity)
            }.buttonStyle(AuthenticationButtonStyle(provider: .google))
            Button(action: {authObject.signInWithFacebook()}) {
                ZStack {
                    HStack {
                        Image("facebookSignInLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Spacer()
                    }
                    
                    Text("Sign in with Facebook")
                    Spacer()
                }.frame(maxWidth: .infinity)
            }.buttonStyle(AuthenticationButtonStyle(provider: .facebook))
        }.padding()
    }
}

struct SignInButtons_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init(red: 0.87, green: 0.90, blue: 0.91)
                .ignoresSafeArea()
            SignInButtons()
        }
    }
}
