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
    
    init() {
        initialSetup()
    }
    
    var body: some View {
        if appState.currentUser == nil {
            NavigationStack(path: $appState.path,
                            root: {
                LoginView(viewModel: LoginVM())
            })
            .environmentObject(appState)
        } else {
            NavigationStack(path: $appState.path,
                            root: {
                TabBarView(viewModel: TabBarVM())
            })
            .environmentObject(appState)
        }
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
