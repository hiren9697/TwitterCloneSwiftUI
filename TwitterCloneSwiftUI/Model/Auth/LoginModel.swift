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
    
    private func isValidEmail(email: String)-> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidPassword(password: String)-> Bool {
        return password.count >= 6
    }
}
