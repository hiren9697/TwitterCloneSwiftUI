//
//  Fonts.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 22/04/23.
//

import UIKit


func printAllFonts() {
    for family in UIFont.familyNames {
        print("\(family)")

        for name in UIFont.fontNames(forFamilyName: family) {
            print("   \(name)")
        }
    }
}

enum AppFont: String {
    case regular = "SFProText-Regular"
    case regularItalic = "SFProText-RegularItalic"
    case ultraLight = "SFProText-Ultralight"
    case ultraLightItalic = "SFProText-UltralightItalic"
    case thin = "SFProText-Thin"
    case thinItalic = "SFProText-ThinItalic"
    case light = "SFProText-Light"
    case lightItalic = "SFProText-LightItalic"
    case medium = "SFProText-Medium"
    case mediumItalic = "SFProText-MediumItalic"
    case semibold = "SFProText-Semibold"
    case semiboldItalic = "SFProText-SemiboldItalic"
    case bold = "SFProText-Bold"
    case boldItalic = "SFProText-BoldItalic"
    case heavy = "SFProText-Heavy"
    case heavyItalic = "SFProText-HeavyItalic"
    case black = "SFProText-Black"
    case blackItalic = "SFProText-BlackItalic"
    
    func withSize(_ size: CGFloat)-> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
