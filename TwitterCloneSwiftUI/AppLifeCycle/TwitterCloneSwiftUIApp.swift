//
//  TwitterCloneSwiftUIApp.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import SwiftUI
import FirebaseCore

// MARK: - App
@main
struct TwitterCloneSwiftUIApp: App {
    init() {
        configuareApp()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .onAppear(perform: {
//                    configuareApp()
//                })
        }
    }
    
    func configuareApp() {
        FirebaseApp.configure()
    }
}

// MARK: - App Delegate
//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//    return true
//  }
//}
