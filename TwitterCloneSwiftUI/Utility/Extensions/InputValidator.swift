//
//  InputValidator.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 21/05/23.
//

import Foundation

final class InputValidator {
    
    internal func containsSpecialCharacters(text: String)-> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if text.rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        } else {
            return false
        }
    }
    
    internal func isValidEmail(email: String)-> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
