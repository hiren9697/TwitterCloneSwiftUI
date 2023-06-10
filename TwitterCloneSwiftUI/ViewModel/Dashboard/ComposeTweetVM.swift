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
    @Published var localPhotos: [LocalImage] = []
    @Published var selectedPhotoPickerItems: [PhotosPickerItem] = [] {
        didSet {
            processSelectedImages()
        }
    }
    @Published var selectedImages: [LocalImage] = []
    let localPhotoSize: CGSize = CGSize(width: 100, height: 100)
}

// MARK: - Helper method(s)
extension ComposeTweetVM {
    
    
}

// MARK: - Photo library
extension ComposeTweetVM {
    
    /// Process images selected by user
    /// Converts PhotosPickerItem to LocalImage
    private func processSelectedImages() {
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
    
    /// Check photo library access permission
    /// If permission is not determined yet, Requestes access permission
    internal func checkPhotoLibraryAccessPermission() {
        // 2. Request access
        func requestPhotoAccessAuthorization() {
            PHPhotoLibrary.requestAuthorization {[weak self] status in
                if status == .authorized {
                    self?.fetchLocalPhotos()
                }
            }
        }
        
        // 1. Check current authorization status
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized: fetchLocalPhotos()
        case .notDetermined: requestPhotoAccessAuthorization()
        default: break
        }
    }
    
    /// Fetchs some local photos
    private func fetchLocalPhotos() {
        
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:
                                                            "creationDate", ascending: true)]
        let fetchResult: PHFetchResult =
        PHAsset.fetchAssets (with: .image,
                             options: fetchOptions)
        if fetchResult.count > 0 {
            DispatchQueue.main.async {[weak self] in
                guard let strongSelf = self else { return }
                var images: [LocalImage] = []
                for i in 0 ..< fetchResult.count {
                    imgManager.requestImage(for: fetchResult.object(at: i),
                                            targetSize: strongSelf.localPhotoSize,
                                            contentMode: .aspectFill,
                                            options: requestOptions) {[weak self] image, dictionary in
                        if let image = image {
                            images.append(LocalImage(image: Image(uiImage: image),
                                                     uiImage: image))
                            if i == fetchResult.count - 1 {
                                self?.localPhotos = images
                            }
                        }
                    }
                }
            }
        }
    }
}
