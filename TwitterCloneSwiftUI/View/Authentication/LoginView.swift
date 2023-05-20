//
//  LoginView.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import SwiftUI

// MARK: - View
struct LoginView: View {
    var body: some View {
        ScrollView {
            image
            button
        }
        .frame(maxWidth: .infinity)
        .background(AppColor.cBlue)
        .ignoresSafeArea()
    }
}

// MARK: - UI Components
extension LoginView {
    
    var image: some View {
        Image("ic_twitter_logo_auth")
            .padding(.top, 70)
    }
    
    var button: some View {
        AuthButton(title: "Login",
                   action: {
            Log.info("Login tapped")
        })
    }
}

// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
