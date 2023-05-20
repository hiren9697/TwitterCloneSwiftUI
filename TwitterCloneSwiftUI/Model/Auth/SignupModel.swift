//
//  SignupModel.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import Foundation

// MARK: - Input Fields
enum SignupInputFields {
    case email
    case password
    case fullname
    case username
}

// MARK: - Error
enum SignupInputError: Error, LocalizedError, CustomStringConvertible {
    
    case emptyEmail
    case emptyPassword
    case emptyFullname
    case emptyUsername
    case invalidEmail
    case invalidPassword
    case invalidFullname
    case invalidUsername
    
    var errorDescription: String? {
        switch self {
        case .emptyEmail: return "Please enter email"
        case .emptyPassword: return "Please enter password"
        case .emptyFullname: return "Please enter fullname"
        case .emptyUsername: return "Please enter username"
        case .invalidEmail: return "Please enter valid email"
        case .invalidPassword: return "Password must be of minimum 6 characters"
        case .invalidFullname: return "Fullname must be of minimum 4 characters"
        case .invalidUsername: return "Username must be of minimum 4 characters"
        }
    }
    
    var description: String {
        switch self {
        case .emptyEmail: return "Email is empty"
        case .emptyPassword: return "Password is empty"
        case .emptyFullname: return "Fullname is empty"
        case .emptyUsername: return "Username is empty"
        case .invalidEmail: return "Email is invalid"
        case .invalidPassword: return "Password is invalid, lessthan 6 characters"
        case .invalidFullname: return "Fullname is invalid, lessthan 4 characters"
        case .invalidUsername: return "Username is invalid, lessthan 4 characters"
        }
    }
}
