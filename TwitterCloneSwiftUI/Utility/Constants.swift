//
//  Constants.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 06/05/23.
//

import UIKit
import SwiftUI_SimpleToast

struct Application {
    static let shared = UIApplication.shared
    static let toastOption = SimpleToastOptions(hideAfter: 3,
                                                animation: .easeInOut(duration: 0.27),
                                                modifierType: .slide)
}

// MARK: - Geometry
struct Geometry {
    static let screen = UIScreen.main
    static let frame = screen.bounds
    static let width = frame.width
    static let height = frame.height
}
