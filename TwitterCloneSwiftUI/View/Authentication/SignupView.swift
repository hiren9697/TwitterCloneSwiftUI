//
//  SignupView.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import SwiftUI
import PhotosUI

// MARK: - View
struct SignupView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: SignupVM
    @FocusState var focusedField: SignupInputFields?
    
    init(signupVM: SignupVM) {
        _viewModel = StateObject(wrappedValue: signupVM)
    }
    
    var body: some View {
        ZStack {
            // 1. Content
            ScrollView {
                image
                tfs
                button
                signinText
            }
            .frame(maxWidth: .infinity)
            .background(AppColor.blue)
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .simpleToast(isPresented: $viewModel.showToast,
                         options: Application.toastOption,
                         content: { ToastView(message: viewModel.errorMessage, type: .failure) })
            .disabled(viewModel.isLoading)
            // 2. Loader
            if viewModel.isLoading {
                LoadingView(color: AppColor.red)
            }
        }
        .onChange(of: viewModel.currentUser) { newValue in
            if let user = newValue {
                appState.saveUser(user: user)
            }
        }
    }
}

// MARK: - UI Components
extension SignupView {
    
    var image: some View {
        PhotosPicker(selection: $viewModel.profilePickerItem,
                     label: {
            // If user has selected image
            if let photo = viewModel.profileImage {
                photo
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(
                        Circle()
                    )
                    .overlay(
                        Circle()
                            .stroke(AppColor.white, lineWidth: 2)
                    )
                    .padding(.top, 70)
            } else {
            // User hasn't selected image
                Image("ic_user_placeholder")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(AppColor.white)
                    .frame(width: 80, height: 80)
                    .padding(.top, 70)
            }
        })
    }
    
    var tfs: some View {
        VStack {
            // 1. Email
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
            // 2. Password
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
            // 3. Fullname
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
            // 4. Username
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
    
    var signinText: some View {
        Button(action: {
            presentation.wrappedValue.dismiss()
        },
               label: {
            Text("Already have an account **SignIn**")
                .font(Font.custom(AppFont.regular.rawValue, size: 14))
                .foregroundColor(AppColor.white)
        })
        .padding()
    }
}

// MARK: - Preview
struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(signupVM: SignupVM())
    }
}
