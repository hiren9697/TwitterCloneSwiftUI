//
//  SignupVM.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import SwiftUI
import PhotosUI
import FirebaseAuth

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
    @Published var isLoading: Bool = false
    
    let inputValidator = AuthInputValidator()
    let service = UserService()
    var inputErrorMessage = ""
}

// MARK: - Helper method(s)
extension SignupVM {
    
    internal func signup() {
        if validateInputs() {
            registerUser()
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
    
    private func getData(userId: String,
                         profileImageURL: String?)-> [String: Any] {
        var data = [
            "userId": userId,
            "email": email,
            "fullname": fullname,
            "username": username
        ]
        if let profileImageURL = profileImageURL {
            data["profileImage"] = profileImageURL
        }
        return data
    }
    
    private func showError(error: Error) {
        inputErrorMessage = error.localizedDescription
        showToast = true
        isLoading = false
    }
    
    private func showError(message: String) {
        inputErrorMessage = message
        showToast = true
        isLoading = false
    }
}

// MARK: - API method(s)
extension SignupVM {
    
    private func registerUser() {
        isLoading = true
        // 1. Create user in firebase authentication
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] result, error in
            guard let strongSelf = self else { return }
            if let error = error {
                Log.error("Error in registering user: \(error.localizedDescription)")
                strongSelf.showError(error: error)
            }
            Log.success("Created new user successfully")
            // 2. Store user's information
            if let userId = result?.user.uid {
                strongSelf.storeUserData(userId: userId)
            } else {
                Log.error("Couldn't get user data in register user")
                strongSelf.showError(message: AppMessage.somethingWentWrong)
            }
        }
    }
    
    private func storeUserData(userId: String) {
        service.storeUserInformation(userId: userId,
                                     data: getData(userId: userId, profileImageURL: nil)) {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(_):
                Log.success("Stored user information successfully")
                strongSelf.isLoading = false
            case .failure(let error):
                Log.error("Error in storing user information: \(error.localizedDescription)")
                strongSelf.showError(error: error)
            }
        }
    }
}
