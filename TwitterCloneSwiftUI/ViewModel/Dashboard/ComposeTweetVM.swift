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
    @Published var localMedia: [LocalMediaRepresentable] = []
    @Published var selectedPhotoPickerItems: [PhotosPickerItem] = [] {
        didSet {
            processSelectedImages()
        }
    }
    @Published var selectedMedia: [LocalMediaRepresentable] = []
    let localPhotoSize: CGSize = CGSize(width: 78, height: 78)
}

// MARK: - Helper method(s)
extension ComposeTweetVM {
    
    
}

// MARK: - Photo library
extension ComposeTweetVM {
    
    /// Process images and videos selected by user
    /// Converts PhotosPickerItem to LocalMedia
    private func processSelectedImages() {
        
        func loadTransferable<T: Transferable>(type: T.Type,
                                               item: PhotosPickerItem,
                                               completion: @escaping (T)-> Void) {
            item.loadTransferable(type: type) { result in
                switch result {
                case .success(let video):
                    //Log.success("Video URL: \(video)")
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
        
        func appendVideo(url: URL) {
            DispatchQueue.main.async {
                if let thumbnailImage = url.generateThumbnail() {
                    let localVideoMedia = LocalVideoMedia(thumbnailImage: thumbnailImage,
                                                          url: url,
                                                          videoDuration: nil)
                    self.selectedMedia.append(LocalMediaRepresentable(videoMedia: localVideoMedia))
                } else {
                    Log.error("Couldn't generate thumbnail with URL: \(url)")
                }
            }
        }
        
        func appendImage(url: URL) {
            DispatchQueue.main.async {
                do {
                    let imageData = try Data(contentsOf: url)
                    if let image = UIImage(data: imageData) {
                        let localImageMedia = LocalImageMedia(uiImage: image)
                        self.selectedMedia.append(LocalMediaRepresentable(imageMedia: localImageMedia))
                    }
                } catch let error as NSError {
                    Log.error("Error in fetching image data from url: \(error.localizedDescription)")
                }
            }
        }
        
        DispatchQueue.main.async {
            self.selectedMedia.removeAll()
        }
        selectedPhotoPickerItems.forEach { item in
            if item.supportedContentTypes.contains([.video]) {
                loadTransferable(type: VideoTransferable.self,
                                 item: item,
                                 completion: { video in
                    Log.success("Video URL: \(video.url)")
                    appendVideo(url: video.url)
                })
            } else if item.supportedContentTypes.contains([.mpeg]) {
                loadTransferable(type: MpegTransferable.self,
                                 item: item,
                                 completion: { video in
                    Log.success("Video URL: \(video.url)")
                    appendVideo(url: video.url)
                })
            } else if item.supportedContentTypes.contains([.movie]) {
                loadTransferable(type: MovieTransferable.self,
                                 item: item,
                                 completion: { video in
                    Log.success("Video URL: \(video.url)")
                    appendVideo(url: video.url)
                })
            } else if item.supportedContentTypes.contains([.mpeg4Movie]) {
                loadTransferable(type: Mpeg4MovieTransferable.self,
                                 item: item,
                                 completion: { video in
                    Log.success("Video URL: \(video.url)")
                    appendVideo(url: video.url)
                })
            } else if item.supportedContentTypes.contains([.video]) {
                loadTransferable(type: VideoTransferable.self,
                                 item: item,
                                 completion: { video in
                    Log.success("Video URL: \(video.url)")
                    appendVideo(url: video.url)
                })
            } else if item.supportedContentTypes.contains([.quickTimeMovie]) {
                loadTransferable(type: QuickTimeMovieTransferable.self,
                                 item: item,
                                 completion: { video in
                    Log.success("Video URL: \(video.url)")
                    appendVideo(url: video.url)
                })
            } else if item.supportedContentTypes.contains([.mpeg2Video]) {
                loadTransferable(type: Mpeg2VideoTransferable.self,
                                 item: item,
                                 completion: { video in
                    Log.success("Video URL: \(video.url)")
                    appendVideo(url: video.url)
                })
            } else if item.supportedContentTypes.contains([.appleProtectedMPEG4Video]) {
                loadTransferable(type: AppleProtectedMpeg4VideoTransferable.self,
                                 item: item,
                                 completion: { video in
                    Log.success("Video URL: \(video.url)")
                    appendVideo(url: video.url)
                })
            } else if item.supportedContentTypes.contains([.jpeg]) {
                loadTransferable(type: JpegTransferable.self,
                                 item: item,
                                 completion: { image in
                    Log.success("Image URL: \(image.url)")
                    appendImage(url: image.url)
                })
            } else if item.supportedContentTypes.contains([.png]) {
                loadTransferable(type: PngTransferable.self,
                                 item: item,
                                 completion: { image in
                    Log.success("Image URL: \(image.url)")
                    appendImage(url: image.url)
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
                        self.selectedMedia.append(LocalMediaRepresentable(imageMedia: localImageMedia))
                    }
                })
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
                        let localImageMedia = LocalImageMedia(uiImage: image)
                        self?.localMedia.append(LocalMediaRepresentable(imageMedia: localImageMedia))
                    }
                }
            }
        }
        
        func processVideoAsset(asset: PHAsset) {
            imgManager.requestAVAsset(forVideo: asset,
                                      options: videoOptions) {[weak self] asset, audio, dictionary in
                //print(dictionary)
                if let urlAsset = asset as? AVURLAsset {
                    let totalSeconds = CMTimeGetSeconds(urlAsset.duration)
                    if let thumbnailImage = urlAsset.url.generateThumbnail() {
                        DispatchQueue.main.async {[weak self] in
                            let localVideoMedia = LocalVideoMedia(thumbnailImage: thumbnailImage,
                                                                  url: urlAsset.url,
                                                                  videoDuration: VideoDuration(totalSeconds: totalSeconds))
                            self?.localMedia.append(LocalMediaRepresentable(videoMedia: localVideoMedia))
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

