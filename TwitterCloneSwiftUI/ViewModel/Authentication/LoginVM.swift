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
    @Published var currentUser: User?
    
    let inputValidator = AuthInputValidator()
    let service = UserService()
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
        isLoading = true
        Auth.auth().signIn(withEmail: email,
                           password: password) {[weak self] result, error in
            guard let strongSelf = self else { return }
            strongSelf.isLoading = false
            if let error = error {
                strongSelf.showError(error: error)
            } else {
                Log.success("User logged in successfully")
                strongSelf.service.fetchProfile { result in
                    switch result {
                    case .success(let user):
                        Log.success("Fetched user's profile successfully")
                        strongSelf.currentUser = user
                    case .failure(let error):
                        strongSelf.showError(error: error)
                    }
                }
            }
        }
    }
}
