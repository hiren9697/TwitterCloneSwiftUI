//
//  LoginModel.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import Foundation

// MARK: - Input Fields
enum LoginInputFields {
    case email
    case password
}

// MARK: - Error
enum LoginInputError: Error, LocalizedError, CustomStringConvertible {
    
    case emptyEmail
    case emptyPassword
    case invalidEmail
    case invalidPassword
    
    var errorDescription: String? {
        switch self {
        case .emptyEmail: return "Please enter email"
        case .emptyPassword: return "Please enter password"
        case .invalidEmail: return "Please enter valid email"
        case .invalidPassword: return "Password must be of minimum 6 characters"
        }
    }
    
    var description: String {
        switch self {
        case .emptyEmail: return "Email is empty"
        case .emptyPassword: return "Password is empty"
        case .invalidEmail: return "Email is invalid"
        case .invalidPassword: return "Password is invalid, lessthan 6 characters"
        }
    }
}

// MARK: - Validator
class AuthInputValidator {
    
    let inputValidator = InputValidator()
    
    internal func validateLoginInputs(email: String, passwrod: String)-> Result<Void, LoginInputError> {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = passwrod.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedEmail.isEmpty {
            return .failure(.emptyEmail)
        } else if trimmedPassword.isEmpty {
            return .failure(.emptyPassword)
        } else if !isValidEmail(email: trimmedEmail) {
            return .failure(.invalidEmail)
        } else if !isValidPassword(password: trimmedPassword) {
            return .failure(.invalidPassword)
        } else {
            return .success(())
        }
    }
    
    internal func validateSignupInputs(email: String,
                                       passwrod: String,
                                       fullname: String,
                                       username: String)-> Result<Void, SignupInputError> {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = passwrod.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedFullname = fullname.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedEmail.isEmpty {
            return .failure(.emptyEmail)
        } else if trimmedPassword.isEmpty {
            return .failure(.emptyPassword)
        } else if trimmedFullname.isEmpty {
            return .failure(.emptyFullname)
        } else if trimmedUsername.isEmpty {
            return .failure(.emptyUsername)
        } else if !isValidEmail(email: trimmedEmail) {
            return .failure(.invalidEmail)
        } else if !isValidPassword(password: trimmedPassword) {
            return .failure(.invalidPassword)
        } else if !isValidFullname(fullname: trimmedFullname) {
            return .failure(.invalidFullname)
        } else if !isValidUsername(username: trimmedUsername) {
            return .failure(.invalidUsername)
        } else {
            return .success(())
        }
    }
    
    private func isValidEmail(email: String)-> Bool {
        inputValidator.isValidEmail(email: email)
    }
    
    private func isValidPassword(password: String)-> Bool {
        return password.count >= 6
    }
    
    private func isValidFullname(fullname: String)-> Bool {
        return fullname.count >= 4
    }
    
    private func isValidUsername(username: String)-> Bool {
        return username.count >= 4 && !inputValidator.containsSpecialCharacters(text: username)
    }
}
