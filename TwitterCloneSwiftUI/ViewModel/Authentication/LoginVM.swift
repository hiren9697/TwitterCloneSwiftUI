//
//  LoginVM.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import SwiftUI

// MARK: - VM
class LoginVM: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showToast: Bool = false
    
    let inputValidator = AuthInputValidator()
    var inputErrorMessage = ""
}

// MARK: - Helper method(s)
extension LoginVM {
    
    internal func login() {
        if validateInputs() {
            loginAPI()
        }
    }
    
    private func validateInputs()-> Bool {
        let result = inputValidator.validateLoginInputs(email: email, passwrod: password)
        switch result {
        case .success(_):
            return true
        case .failure(let error):
            Log.error("Login input error: \(error.localizedDescription)")
            inputErrorMessage = error.localizedDescription
            showToast = true
            return false
        }
    }
}

// MARK: - API method(s)
extension LoginVM {
    
    private func loginAPI() {
        
    }
}
