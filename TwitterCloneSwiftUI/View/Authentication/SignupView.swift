//
//  SignupView.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import SwiftUI

// MARK: - View
struct SignupView: View {
    @StateObject var viewModel = SignupVM()
    @FocusState var focusedField: SignupInputFields?
    
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
                     content: { SuccessToastView(message: viewModel.inputErrorMessage, type: .failure) })
    }
}

// MARK: - UI Components
extension SignupView {
    
    var image: some View {
        Image("ic_user_placeholder")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(AppColor.white)
            .frame(width: 80, height: 80)
            .padding(.top, 70)
    }
    
    var tfs: some View {
        VStack {
            AuthTF<SignupInputFields>(text: $viewModel.email,
                                     isSecureField: false,
                                     focusedField: $focusedField,
                                     placeholder: "Email",
                                     leadingIconName: "envelope",
                                     keyboardType: .emailAddress,
                                     capitalization: .never,
                                     submitLabel: .next,
                                     fieldType: SignupInputFields.email,
                                     onSubmit: {
                focusedField = .password
            })
            AuthTF<SignupInputFields>(text: $viewModel.password,
                                     isSecureField: true,
                                     focusedField: $focusedField,
                                     placeholder: "Password",
                                     leadingIconName: "key",
                                     keyboardType: .asciiCapable,
                                     capitalization: .never,
                                     submitLabel: .done,
                                     fieldType: SignupInputFields.password,
                                     onSubmit: {
                focusedField = .fullname
            })
            AuthTF<SignupInputFields>(text: $viewModel.fullname,
                                     isSecureField: false,
                                     focusedField: $focusedField,
                                     placeholder: "Fullname",
                                     leadingIconName: "newspaper",
                                     keyboardType: .asciiCapable,
                                     capitalization: .words,
                                     submitLabel: .done,
                                     fieldType: SignupInputFields.fullname,
                                     onSubmit: {
                focusedField = .username
            })
            AuthTF<SignupInputFields>(text: $viewModel.username,
                                     isSecureField: false,
                                     focusedField: $focusedField,
                                     placeholder: "Username",
                                     leadingIconName: "person",
                                     keyboardType: .asciiCapable,
                                     capitalization: .never,
                                     submitLabel: .done,
                                     fieldType: SignupInputFields.username,
                                     onSubmit: {
                focusedField = nil
            })
        }
        .padding()
    }
    
    var button: some View {
        AuthButton(title: "Register",
                   action: {
            Application.shared.endEditing()
            viewModel.signup()
        })
    }
}

// MARK: - Preview
struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
