//
//  AuthTF.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import SwiftUI

// MARK: - View
struct AuthTF<FieldType: Hashable>: View {
    @State var isFocusd: Bool = false
    @Binding var text: String
    let isSecureField: Bool
    var focusedField: FocusState<FieldType?>.Binding
    let placeholder: String
    let leadingIconName: String
    let keyboardType: UIKeyboardType
    let submitLabel: SubmitLabel
    let fieldType: FieldType
    let onSubmit: VoidCallback
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. Content
            HStack {
                // 1. Icon
                Image(systemName: leadingIconName)
                    .foregroundColor(isFocusd ? AppColor.white : AppColor.cD3D3D3)
                // 2. TextField
                if isSecureField {
                    SecureField(placeholder,
                                text: $text)
                    .font(Font.custom(AppFont.regular.rawValue, size: 14))
                    .foregroundColor(AppColor.white)
                    .tint(AppColor.white)
                    .keyboardType(keyboardType)
                    .submitLabel(submitLabel)
                    .focused(focusedField.projectedValue, equals: fieldType)
                    .onSubmit(onSubmit)
                } else {
                    TextField(placeholder,
                              text: $text,
                              onEditingChanged: { isEditing in
                        isFocusd = isEditing
                    })
                    .font(Font.custom(AppFont.regular.rawValue, size: 14))
                    .foregroundColor(AppColor.white)
                    .tint(AppColor.white)
                    .keyboardType(keyboardType)
                    .submitLabel(submitLabel)
                    .focused(focusedField.projectedValue, equals: fieldType)
                    .onSubmit(onSubmit)
                }
            }
            .frame(height: 44)
            // 2. Divider
            Divider()
                .frame(height: 0.8)
                .background(isFocusd ? AppColor.white : AppColor.cD3D3D3)
        }
    }
}

// MARK: - Preview
struct AuthTF_Previews: PreviewProvider {
    static var previews: some View {
        AuthTF<LoginInputFields>(text: .constant(""),
                                 isSecureField: false,
                                 focusedField: FocusState<LoginInputFields?>().projectedValue,
                                 placeholder: "Email",
                                 leadingIconName: "envelope",
                                 keyboardType: .asciiCapable,
                                 submitLabel: .next,
                                 fieldType: LoginInputFields.email,
                                 onSubmit: {})
    }
}
