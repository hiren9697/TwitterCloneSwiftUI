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
    let id = UUID().uuidString
    
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

extension APILoadingViewModel: Hashable {
    static func == (lhs: APILoadingViewModel, rhs: APILoadingViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
