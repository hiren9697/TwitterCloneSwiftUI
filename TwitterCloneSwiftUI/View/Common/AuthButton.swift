//
//  AppButton.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import SwiftUI

// MARK: - View
struct AuthButton: View {
    
    let title: String
    let action: VoidCallback
    
    var body: some View {
        Button(action: action,
               label: {
            Text(title)
                .font(Font.custom(AppFont.semibold.rawValue,
                                  size: 16))
                .foregroundColor(AppColor.blue)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(AppColor.primaryBackground)
                )
                .padding()
        })
    }
}

// MARK: - Preview
struct AuthButton_Previews: PreviewProvider {
    static var previews: some View {
        AuthButton(title: "Login",
                   action: {})
    }
}
