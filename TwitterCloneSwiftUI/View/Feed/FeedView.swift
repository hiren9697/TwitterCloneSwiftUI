//
//  FeedView.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 27/05/23.
//

import SwiftUI

// MARK: - View
struct FeedView: View {
    
    @StateObject var viewModel = FeedVM()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // 1. List of tweets
            List {
                
            }
            // 2. Create tweet button
            Button(action: {
                viewModel.isTweetComposePresented = true
            },
                   label: {
                Image("ic_add_tweet")
            })
            .padding(.trailing, 11)
            .padding(.bottom, 11)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $viewModel.isTweetComposePresented) {
            ComposeTweetView()
        }
    }
}

// MARK: - Preview
struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
