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
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: LoginVM
    @FocusState var focusedField: LoginInputFields?
    
    init(viewModel: LoginVM) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            // 1. Content
            ScrollView {
                image
                tfs
                button
                signupText
            }
            .frame(maxWidth: .infinity)
            .background(AppColor.blue)
            .ignoresSafeArea()
            .simpleToast(isPresented: $viewModel.showToast,
                         options: Application.toastOption,
                         content: { ToastView(message: viewModel.errorMessage, type: .failure) })
            // 2. Loader
            if viewModel.isLoading {
                LoadingView(color: AppColor.white)
            }
        }
        .onChange(of: viewModel.currentUser) { newValue in
            if let user = newValue {
                appState.saveUser(user: user)
            }
        }
        .navigationDestination(for: SignupVM.self,
                               destination: { signupVM in
            SignupView(signupVM: signupVM)
        })
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
                                     capitalization: .never,
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
                                     capitalization: .never,
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
            Application.shared.endEditing()
            viewModel.login()
        })
    }
    
    var signupText: some View {
        NavigationLink(value: SignupVM(),
                       label: {
            Text("Don't have an account **SignUp**")
                .font(Font.custom(AppFont.regular.rawValue, size: 14))
                .foregroundColor(AppColor.white)
        })
        .padding()
    }
}

// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginVM())
    }
}
