//
//  LoginView.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import SwiftUI
import SwiftUI_SimpleToast

// MARK: - View
struct LoginView: View {
    @StateObject var viewModel = LoginVM()
    @FocusState var focusedField: LoginInputFields?
    
    var body: some View {
        ScrollView {
            image
            tfs
            button
        }
        .frame(maxWidth: .infinity)
        .background(AppColor.blue)
        .ignoresSafeArea()
        .simpleToast(isPresented: $viewModel.showToast,
                     options: Application.toastOption,
                     content: { SuccessToastView(message: "Simple message", type: .success) })
    }
}

// MARK: - UI Components
extension LoginView {
    
    var image: some View {
        Image("ic_twitter_logo_auth")
            .padding(.top, 70)
    }
    
    var tfs: some View {
        VStack {
            AuthTF<LoginInputFields>(text: $viewModel.email,
                                     isSecureField: false,
                                     focusedField: $focusedField,
                                     placeholder: "Email",
                                     leadingIconName: "envelope",
                                     keyboardType: .emailAddress,
                                     submitLabel: .next,
                                     fieldType: LoginInputFields.email,
                                     onSubmit: {
                focusedField = .password
            })
            AuthTF<LoginInputFields>(text: $viewModel.password,
                                     isSecureField: true,
                                     focusedField: $focusedField,
                                     placeholder: "Password",
                                     leadingIconName: "key",
                                     keyboardType: .asciiCapable,
                                     submitLabel: .done,
                                     fieldType: LoginInputFields.password,
                                     onSubmit: {
                focusedField = nil
            })
        }
        .padding()
    }
    
    var button: some View {
        AuthButton(title: "Login",
                   action: {
            viewModel.showToast = true
            Application.shared.endEditing()
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
