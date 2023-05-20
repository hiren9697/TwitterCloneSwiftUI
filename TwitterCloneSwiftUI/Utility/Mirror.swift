//
//  Mirror.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 22/04/23.
//

import Foundation

protocol Mirrorable {
    func logPropertiesWithValue(reflect: Mirror?)
}

extension Mirrorable {
    func logPropertiesWithValue(reflect: Mirror? = nil) {
        let mirror = reflect ?? Mirror(reflecting: self)
        if mirror.superclassMirror != nil {
            self.logPropertiesWithValue(reflect: mirror.superclassMirror)
        }

        for (index, attr) in mirror.children.enumerated() {
            if let property_name = attr.label {
                print("\(mirror.description) \(index): \(property_name) = \(attr.value)")
            }
        }
        print("\n")
    }
}
