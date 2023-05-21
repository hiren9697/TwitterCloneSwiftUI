//
//  SignupVM.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import SwiftUI
import PhotosUI

// MARK: - VM
class SignupVM: ObservableObject {
    @Published var profileImage: Image?
    @Published var profilePickerItem: PhotosPickerItem? {
        didSet {
            setProfileImage()
        }
    }
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
            inputErrorMessage = ""
            showToast = false
            return true
        case .failure(let error):
            Log.error("Signup input error: \(error.localizedDescription)")
            inputErrorMessage = error.localizedDescription
            showToast = true
            return false
        }
    }
    
    internal func setProfileImage() {
        guard let pickerItem = profilePickerItem else {
            return
        }
        pickerItem.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                guard let data = data,
                let uiImage = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    self.profileImage = Image(uiImage: uiImage)
                }
            case .failure(let error):
                Log.error("Error in loading image from PhotoPickerItem: \(error.localizedDescription)")
                return
            }
        }
    }
}

// MARK: - API method(s)
extension SignupVM {
    
    private func signupAPI() {
        
    }
}
