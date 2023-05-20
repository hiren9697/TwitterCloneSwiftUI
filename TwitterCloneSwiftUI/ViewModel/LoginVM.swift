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
}
