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
    //@Published var localMedia: [LocalImage] = []
    @Published var localMedia: [LocalMedia] = []
    @Published var selectedPhotoPickerItems: [PhotosPickerItem] = [] {
        didSet {
            processSelectedImages()
        }
    }
    @Published var selectedImages: [LocalImage] = []
    let localPhotoSize: CGSize = CGSize(width: 78, height: 78)
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
    
    /// Fetchs local photos & videos
    private func fetchLocalPhotos() {
        
        func processImageAsset(asset: PHAsset) {
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            let imgManager = PHImageManager.default()
            imgManager.requestImage(for: asset,
                                    targetSize: localPhotoSize,
                                    contentMode: .aspectFill,
                                    options: requestOptions) {[weak self] image, dictionary in
                if let image = image {
                    DispatchQueue.main.async {[weak self] in
                        self?.localMedia.append(LocalMedia(displayImage: Image(uiImage: image),
                                                           type: .image,
                                                           uiImage: image,
                                                           videoDurationTotalSeconds: nil))
                    }
                }
            }
        }
        
        func processVideoAsset(asset: PHAsset) {
            imgManager.requestAVAsset(forVideo: asset,
                                      options: videoOptions) {[weak self] asset, audio, dictionary in
                print(dictionary)
                if let urlAsset = asset as? AVURLAsset {
                    let totalSeconds = CMTimeGetSeconds(urlAsset.duration)
                    if let thumbnailImage = urlAsset.url.generateThumbnail() {
                        DispatchQueue.main.async {[weak self] in
                            self?.localMedia.append(LocalMedia(displayImage: Image(uiImage: thumbnailImage),
                                                               type: .video,
                                                               uiImage: thumbnailImage,
                                                               videoURL: urlAsset.url,
                                                               videoDurationTotalSeconds: totalSeconds))
                        }
                    }
                }
            }
        }
        
        let imgManager = PHImageManager.default()

        let videoOptions = PHVideoRequestOptions()
        videoOptions.deliveryMode = .highQualityFormat
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:
                                                            "creationDate", ascending: true)]
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d || mediaType == %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        fetchOptions.fetchLimit = 20
        let assets = PHAsset.fetchAssets(with: fetchOptions)
        Log.info(assets.count)
        for i in 0 ..< assets.count {
            let asset = assets.object(at: i)
            switch asset.mediaType {
            case .image:
                processImageAsset(asset: asset)
            case .video:
                processVideoAsset(asset: asset)
            default: break
            }
            imgManager.requestAVAsset(forVideo: assets.object(at: i),
                                      options: videoOptions) { asset, audio, _ in
                if let urlAsset = asset as? AVURLAsset {
                    Log.info(urlAsset.url)
                }
            }
        }
    }
}

extension URL {
    func generateThumbnail() -> UIImage? {
        do {
            let asset = AVURLAsset(url: self)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            // Swift 5.3
            let cgImage = try imageGenerator.copyCGImage(at: .zero,
                                                         actualTime: nil)
            
            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
    }
}

