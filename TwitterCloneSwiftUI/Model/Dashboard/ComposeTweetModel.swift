//
//  ComposeTweetModel.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 06/06/23.
//

import SwiftUI
import PhotosUI

struct LocalImage: Identifiable {
    let id = UUID().uuidString
    let image: Image
    let uiImage: UIImage
}
