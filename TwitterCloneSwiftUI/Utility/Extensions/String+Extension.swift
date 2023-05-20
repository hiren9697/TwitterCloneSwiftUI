//
//  String+Extension.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 06/05/23.
//

import SwiftUI

extension String {
    
    func getWidth(font: Font) -> CGFloat{
            let attributes = [NSAttributedString.Key.font: font]
            let size = (self as NSString).size(withAttributes: attributes)
            return size.width
        }
}
