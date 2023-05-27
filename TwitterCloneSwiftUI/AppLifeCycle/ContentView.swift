//
//  ContentView.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import SwiftUI

// MARK: - View
struct ContentView: View {
    var body: some View {
        NavigationStack(root: {
            TabBarView()
        })
            .onAppear(perform: {
                initialSetup()
            })
    }
}

// MARK: - Helper method(s)
extension ContentView {
    
    private func initialSetup() {
        UIScrollView.appearance().keyboardDismissMode = .interactive
        UITableView.appearance().keyboardDismissMode = .interactive
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
