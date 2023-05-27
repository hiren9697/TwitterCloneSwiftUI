//
//  LoginVM.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import SwiftUI
import FirebaseAuth

// MARK: - VM
class LoginVM: APILoadingViewModel {
    @Published var email: String = ""
    @Published var password: String = ""
    
    let inputValidator = AuthInputValidator()
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
            showError(error: error)
            return false
        }
    }
}

// MARK: - API method(s)
extension LoginVM {
    
    private func loginAPI() {
        Auth.auth().signIn(withEmail: email,
                           password: password) { result, error in
            
        }
    }
}
