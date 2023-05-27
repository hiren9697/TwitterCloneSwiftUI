//
//  APILoadingViewModel.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 27/05/23.
//

import Foundation

class APILoadingViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showToast: Bool = false
    
    internal func showError(error: Error) {
        errorMessage = error.localizedDescription
        showToast = true
        isLoading = false
    }
    
    internal func showError(message: String) {
        errorMessage = message
        showToast = true
        isLoading = false
    }
}
