//
//  AppState.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 27/05/23.
//

import Foundation
import SwiftUI

// MARK: - AppState
final class AppState: ObservableObject {
    @Published var path = NavigationPath()
    @Published var currentUser: User?
    
    init() {
        getUser()
    }
}

// MARK: - Helper method(s)
extension AppState {
    
    func saveUser(user: User) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            UserDefaults.standard.set(data, forKey: "user")
            self.currentUser = user
            Log.success("Store user data locally")
            path = NavigationPath()
        } catch {
            Log.error("Unable to Encode User \(error.localizedDescription)")
        }
    }
    
    func getUser() {
        if let data = UserDefaults.standard.object(forKey: "user") as? Data {
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                self.currentUser = user
                Log.success("Found local user data")
            } catch {
                Log.error("Unable to Decode User \(error.localizedDescription)")
            }
        } else {
            Log.warning("Didn't found local user data")
        }
    }
}
