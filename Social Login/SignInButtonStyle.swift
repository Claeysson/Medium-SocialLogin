//
//  SignInButtonStyle.swift
//  Social Login
//
//  Created by Martin Claesson on 2021-08-06.
//

import SwiftUI

struct AuthenticationButtonStyle: ButtonStyle {
    
    enum Provider {
        case google
        case apple
        case facebook
    }
    
    var backgroundColor = Color.white
    var foregroundColor = Color.black
    
    init(provider: Provider) {
        switch provider {
        case .apple:
            backgroundColor = Color.black
            foregroundColor = Color.white
        case .google:
            backgroundColor = Color.white
            foregroundColor = Color.black
        case .facebook:
            backgroundColor = Color.init(red: 0.09, green: 0.47, blue: 0.95)
            foregroundColor = Color.white
        }
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.leading, 0)
            .padding(.all)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .cornerRadius(100)
            .font(.system(size: 20, weight: .semibold, design: .default))
    }
}
