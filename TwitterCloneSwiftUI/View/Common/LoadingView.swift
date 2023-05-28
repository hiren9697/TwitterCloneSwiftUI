//
//  LoadingView.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 27/05/23.
//

import SwiftUI

// MARK: - View
struct LoadingView: View {
    
    let color: Color
    
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: color))
    }
}

// MARK: - Preview
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(color: AppColor.white)
    }
}
