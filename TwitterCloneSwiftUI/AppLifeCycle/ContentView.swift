//
//  ContentView.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import SwiftUI
import FirebaseAuth

// MARK: - View
struct ContentView: View {
    @StateObject var appState = AppState()
    
    var body: some View {
        NavigationStack(root: {
            if appState.user == nil {
                LoginView()
            } else {
                TabBarView()
            }
        })
        .environmentObject(appState)
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
