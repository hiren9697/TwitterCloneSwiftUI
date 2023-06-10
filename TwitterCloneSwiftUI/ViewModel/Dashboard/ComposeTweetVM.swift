//
//  ComposeTweetVM.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 28/05/23.
//

import UIKit
import Photos
import SwiftUI
import _PhotosUI_SwiftUI

// MARK: - View Model
class ComposeTweetVM: ObservableObject {
    
    @Published var text: String = ""
    @Published var selectedPhotoPickerItems: [PhotosPickerItem] = [] {
        didSet {
            processImages()
        }
    }
    @Published var selectedImages: [LocalImage] = []
}

// MARK: - Helper method(s)
extension ComposeTweetVM {
    
    private func processImages() {
//        var images: [Image] = []
        selectedImages = []
        selectedPhotoPickerItems.forEach { item in
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    guard let data = data,
                    let uiImage = UIImage(data: data) else {
                        return
                    }
                    let image = Image(uiImage: uiImage)
                    DispatchQueue.main.async {
                        self.selectedImages.append(LocalImage(image: image,
                                                              uiImage: uiImage))
                    }
                case .failure(let error):
                    Log.error("Error in loading image from PhotoPickerItem: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
}
