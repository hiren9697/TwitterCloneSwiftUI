//
//  SuccessToastView.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import SwiftUI

enum Toast {
    case success
    case failure
    
    var iconColor: Color {
        switch self {
        case .success: return AppColor.blue
        case .failure: return AppColor.red
        }
    }
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle"
        case .failure: return "x.circle"
        }
    }
    
    var textColor: Color {
        return AppColor.secondaryTextColor
    }
    
    var backgroundColor: Color {
        return AppColor.secondaryBackground
    }
}

// MARK: - View
struct SuccessToastView: View {
    
    let message: String
    let type: Toast
    let backgroundColor: Color?
    let iconColor: Color?
    let textColor: Color?
    let icon: String?
    
    init(message: String,
         type: Toast,
         backgroundColor: Color? = nil,
         iconColor: Color? = nil,
         textColor: Color? = nil,
         icon: String? = nil) {
        self.message = message
        self.type = type
        self.backgroundColor = backgroundColor
        self.iconColor = iconColor
        self.textColor = textColor
        self.icon = icon
    }
    
    var body: some View {
        HStack {
            Image(systemName: icon ?? type.icon)
                .foregroundColor(iconColor ?? type.iconColor)
            Text(message)
                .font(Font.custom(AppFont.regular.rawValue, size: 14))
                .foregroundColor(textColor ?? type.textColor)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(backgroundColor ?? type.backgroundColor)
        
        //.cornerRadius(10)
    }
}

// MARK: - Preview
struct SuccessToastView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessToastView(message: "Sample message", type: .failure, icon: nil)
    }
}
