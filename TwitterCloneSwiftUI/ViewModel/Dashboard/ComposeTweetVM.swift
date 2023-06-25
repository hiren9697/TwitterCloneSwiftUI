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
    @Published var isLoading: Bool = false
    @Published var text: String = ""
    @Published var localMedia: [LocalMediaRepresentable] = []
    @Published var selectedPhotoPickerItems: [PhotosPickerItem] = [] {
        willSet {
          processSelectedMedia(oldValue: selectedPhotoPickerItems,
                               newValue: newValue)
        }
    }
    @Published var selectedMedia: [LocalMediaRepresentable] = []
    let service = TweetService()
    let user: User
    let localPhotoSize: CGSize = CGSize(width: 78,
                                        height: 78)
    let selectedMediaSize: CGSize = CGSize(width: Geometry.width * 0.6,
                                           height: (Geometry.width * 0.6) * 1.5)
    
    init(user: User) {
        self.user = user
    }
}

// MARK: - Helper method(s)
extension ComposeTweetVM {
    
    internal func makeTweet() {
        uploadTweet()
    }
}

// MARK: - Photo library
extension ComposeTweetVM {
    
    /// Process images and videos selected by user
    /// Converts PhotosPickerItem to LocalMedia
    private func processSelectedMedia(oldValue: [PhotosPickerItem],
                                      newValue: [PhotosPickerItem]) {
        
        /// Process video item selected by user
        /// Fetchs url from PhotoPickerItem
        func loadTransferable<T: Transferable>(type: T.Type,
                                               item: PhotosPickerItem,
                                               completion: @escaping (T)-> Void) {
            item.loadTransferable(type: type) { result in
                switch result {
                case .success(let video):
                    if let video = video {
                        completion(video)
                    } else {
                        Log.error("Found nil value in loading transferable")
                    }
                case .failure(let error):
                    Log.error("Error in loading transferable: \(error.localizedDescription)")
                }
            }
        }
        
        /// Generates thumbnai image rom video URL
        /// Appends LocalVideoMidea object to local media array
        func appendVideo(photoPickerItem: PhotosPickerItem,
                         url: URL) {
            DispatchQueue.main.async {
                // 1. Generate thumbnail image
                guard let thumbnailImage = url.generateThumbnail() else {
                    Log.error("Couldn't generate thumbnail with URL: \(url)")
                    return
                }
                // 2. Get video duration
                let asset = AVAsset(url: url)
                let totalSeconds = CMTimeGetSeconds(asset.duration)
                // 3. Append to local media array
                let localVideoMedia = LocalVideoMedia(thumbnailImage: thumbnailImage,
                                                      url: url,
                                                      videoDuration: VideoDuration(totalSeconds: totalSeconds))
                self.selectedMedia.append(LocalMediaRepresentable(localIdentifier: photoPickerItem.itemIdentifier!,
                                                                  videoMedia: localVideoMedia))
            }
        }
        
        /// Appends LocalImageMedia object to local media array
        func appendImage(photoPickerItem: PhotosPickerItem,
                         url: URL) {
            DispatchQueue.main.async {
                do {
                    let imageData = try Data(contentsOf: url)
                    if let image = UIImage(data: imageData) {
                        let localImageMedia = LocalImageMedia(uiImage: image)
                        self.selectedMedia.append(LocalMediaRepresentable(localIdentifier: photoPickerItem.itemIdentifier!,
                                                                          imageMedia: localImageMedia))
                    }
                } catch let error as NSError {
                    Log.error("Error in fetching image data from url: \(error.localizedDescription)")
                }
            }
        }
        
        /// Finds difference between old value and new value
        /// Gives array of picker items need to be added
        /// And array of picker items need to be removed
        func compare()-> (itemsNeedToAdd: [PhotosPickerItem],
                          itemsNeedToRemove: [PhotosPickerItem]) {
            let setOldValue = Set(oldValue)
            let setNewValue = Set(newValue)
            let setNeedToAdd = setNewValue.subtracting(setOldValue)
            let setNeedToRemove = setOldValue.subtracting(setNewValue)
            return (Array(setNeedToAdd), Array(setNeedToRemove))
        }
        
        /// Removes all given items from selected media
        func removeItems(items: [PhotosPickerItem]) {
            let localIdentifiers = items.map { $0.itemIdentifier! }
            selectedMedia.removeAll(where: { localIdentifiers.contains($0.localIdentifier) })
        }
        
        /// Iterate all given photo picker item
        /// Load transferable type
        /// Append to local media array
        func addItems(items: [PhotosPickerItem]) {
            items.forEach { item in
                if item.supportedContentTypes.contains([.video]) {
                    loadTransferable(type: VideoTransferable.self,
                                     item: item,
                                     completion: { video in
                        Log.success("Video URL: \(video.url)")
                        appendVideo(photoPickerItem: item,
                                    url: video.url)
                    })
                } else if item.supportedContentTypes.contains([.mpeg]) {
                    loadTransferable(type: MpegTransferable.self,
                                     item: item,
                                     completion: { video in
                        Log.success("Video URL: \(video.url)")
                        appendVideo(photoPickerItem: item,
                                    url: video.url)
                    })
                } else if item.supportedContentTypes.contains([.movie]) {
                    loadTransferable(type: MovieTransferable.self,
                                     item: item,
                                     completion: { video in
                        Log.success("Video URL: \(video.url)")
                        appendVideo(photoPickerItem: item,
                                    url: video.url)
                    })
                } else if item.supportedContentTypes.contains([.mpeg4Movie]) {
                    loadTransferable(type: Mpeg4MovieTransferable.self,
                                     item: item,
                                     completion: { video in
                        Log.success("Video URL: \(video.url)")
                        appendVideo(photoPickerItem: item,
                                    url: video.url)
                    })
                } else if item.supportedContentTypes.contains([.video]) {
                    loadTransferable(type: VideoTransferable.self,
                                     item: item,
                                     completion: { video in
                        Log.success("Video URL: \(video.url)")
                        appendVideo(photoPickerItem: item,
                                    url: video.url)
                    })
                } else if item.supportedContentTypes.contains([.quickTimeMovie]) {
                    loadTransferable(type: QuickTimeMovieTransferable.self,
                                     item: item,
                                     completion: { video in
                        Log.success("Video URL: \(video.url)")
                        appendVideo(photoPickerItem: item,
                                    url: video.url)
                    })
                } else if item.supportedContentTypes.contains([.mpeg2Video]) {
                    loadTransferable(type: Mpeg2VideoTransferable.self,
                                     item: item,
                                     completion: { video in
                        Log.success("Video URL: \(video.url)")
                        appendVideo(photoPickerItem: item,
                                    url: video.url)
                    })
                } else if item.supportedContentTypes.contains([.appleProtectedMPEG4Video]) {
                    loadTransferable(type: AppleProtectedMpeg4VideoTransferable.self,
                                     item: item,
                                     completion: { video in
                        Log.success("Video URL: \(video.url)")
                        appendVideo(photoPickerItem: item,
                                    url: video.url)
                    })
                } else if item.supportedContentTypes.contains([.jpeg]) {
                    loadTransferable(type: JpegTransferable.self,
                                     item: item,
                                     completion: { image in
                        Log.success("Image URL: \(image.url)")
                        appendImage(photoPickerItem: item,
                                    url: image.url)
                    })
                } else if item.supportedContentTypes.contains([.png]) {
                    loadTransferable(type: PngTransferable.self,
                                     item: item,
                                     completion: { image in
                        Log.success("Image URL: \(image.url)")
                        appendImage(photoPickerItem: item,
                                    url: image.url)
                    })
                }
                else if item.supportedContentTypes.contains([.data]) {
                    loadTransferable(type: Data.self,
                                     item: item,
                                     completion: { data in
                        guard let uiImage = UIImage(data: data) else {
                            return
                        }
                        DispatchQueue.main.async {
                            let localImageMedia = LocalImageMedia(uiImage: uiImage)
                            self.selectedMedia.append(LocalMediaRepresentable(localIdentifier: item.itemIdentifier!,
                                                                              imageMedia: localImageMedia))
                        }
                    })
                }
            }
        }
        
        /// Compare new value and old value
        let compareResult = compare()
        let itemsNeedToAdd = compareResult.itemsNeedToAdd
        let itemsNeedToRemove = compareResult.itemsNeedToRemove
        
        /// Add items if needed
        if !itemsNeedToAdd.isEmpty {
            addItems(items: itemsNeedToAdd)
        }
        /// Remove items if needed
        if !itemsNeedToRemove.isEmpty {
            removeItems(items: itemsNeedToRemove)
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
            let localIdentifier = asset.localIdentifier
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            let imgManager = PHImageManager.default()
            // Passing target size of selected media's height
            // Because when user selects media from local media, we want to have enough resolution
            // If we pass local media size, then media selected from local media will have low resolution
            imgManager.requestImage(for: asset,
                                    targetSize: CGSize(width: selectedMediaSize.height,
                                                       height: selectedMediaSize.height),
                                    contentMode: .aspectFill,
                                    options: requestOptions) {[weak self] image, dictionary in
                if let image = image {
                    DispatchQueue.main.async {[weak self] in
                        let localImageMedia = LocalImageMedia(uiImage: image)
                        self?.localMedia.append(LocalMediaRepresentable(localIdentifier: localIdentifier,
                                                                        imageMedia: localImageMedia))
                    }
                }
            }
        }
        
        func processVideoAsset(asset: PHAsset) {
            let localIdentifier = asset.localIdentifier
            imgManager.requestAVAsset(forVideo: asset,
                                      options: videoOptions) {[weak self] asset, audio, dictionary in
                if let urlAsset = asset as? AVURLAsset {
                    let totalSeconds = CMTimeGetSeconds(urlAsset.duration)
                    if let thumbnailImage = urlAsset.url.generateThumbnail() {
                        DispatchQueue.main.async {[weak self] in
                            let localVideoMedia = LocalVideoMedia(thumbnailImage: thumbnailImage,
                                                                  url: urlAsset.url,
                                                                  videoDuration: VideoDuration(totalSeconds: totalSeconds))
                            self?.localMedia.append(LocalMediaRepresentable(localIdentifier: localIdentifier,
                                                                            videoMedia: localVideoMedia))
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

// MARK: - Web Service method(s)
extension ComposeTweetVM {
    
    private func uploadTweet() {
        isLoading = true
        let images = selectedMedia.compactMap { $0.imageMedia?.uiImage }
        service.uploadTweet(userId: user.id,
                            tweetText: text,
                            images: images,
                            videos: []) {[weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.isLoading = false
        }
    }
}
