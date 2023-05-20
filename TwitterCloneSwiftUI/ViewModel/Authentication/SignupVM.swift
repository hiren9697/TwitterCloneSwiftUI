//
//  SignupVM.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import SwiftUI

// MARK: - VM
class SignupVM: ObservableObject {
    @Published var profileImage: Image?
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullname: String = ""
    @Published var username: String = ""
    @Published var showToast: Bool = false
    
    let inputValidator = AuthInputValidator()
    var inputErrorMessage = ""
}

// MARK: - Helper method(s)
extension SignupVM {
    
    internal func signup() {
        if validateInputs() {
            signupAPI()
        }
    }
    
    private func validateInputs()-> Bool {
        let result = inputValidator.validateSignupInputs(email: email,
                                                         passwrod: password,
                                                         fullname: fullname,
                                                         username: username)
        switch result {
        case .success(_):
            return true
        case .failure(let error):
            Log.error("Signup input error: \(error.localizedDescription)")
            inputErrorMessage = error.localizedDescription
            showToast = true
            return false
        }
    }
}

// MARK: - API method(s)
extension SignupVM {
    
    private func signupAPI() {
        
    }
}
