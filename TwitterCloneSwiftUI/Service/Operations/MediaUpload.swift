//
//  MediaUpload.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 08/07/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

// MARK: - Image Upload
final class ImageUploadOperation: AsyncOperation {
    
    let image: UIImage
    let storage = Storage.storage().reference()
    let completion: ResultURLCallback
    
    init(image: UIImage, completion: @escaping ResultURLCallback) {
        self.image = image
        self.completion = completion
    }
    
    override func main() {
        super.main()
        uploadImage()
    }
    
    private func uploadImage() {
        // 1. Create child reference
        let reference = storage.child("\(DatabaseStorage.tweet.rawValue)/\(getTimeStamp()).jpg")
        // 2. Convert image to data
        guard let data = image.jpegData(compressionQuality: 0.3) else {
            completion(.failure(MediaUploadError.imageConversion))
            state = .isFinished
            return
        }
        // 3. Upload data
        reference.putData(data) {[weak self] metadata, error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.completion(.failure(error))
                self?.state = .isFinished
                return
            }
            // 4. Download url
            reference.downloadURL {[weak self] url, error in
                guard let _ = self else { return }
                if let error = error {
                    strongSelf.completion(.failure(error))
                    self?.state = .isFinished
                    return
                }
                if let url = url {
                    Log.success("Uploaded image: \(strongSelf.image), url: \(url)")
                    strongSelf.completion(.success(url))
                    self?.state = .isFinished
                } else {
                    strongSelf.completion(.failure(RegisterError.emptyProfileImageUrl))
                    self?.state = .isFinished
                }
            }
        }
    }
}

// MARK: - Media
class MediaUploadOperation {
    let queue = OperationQueue()
    let images: [UIImage]
    var videos: [URL]
    let completion: ResultURLsCallback
    var urls: [URL] = []
    var error: Error?
    
    init(images: [UIImage],
         videos: [URL],
         completion: @escaping ResultURLsCallback) {
        self.images = images
        self.videos = videos
        self.completion = completion
    }
    
    func start() {
        // 1. Setup queue
        queue.qualityOfService = .background
        queue.isSuspended = true
        // 2. Add operations
        var operations: [ImageUploadOperation] = []
        for image in images {
            let operation = ImageUploadOperation(image: image,
                                                 completion: {[weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let url):
                    strongSelf.urls.append(url)
                case .failure(let error):
                    /// Cancel all operation, if any specific image upload completes with error
                    strongSelf.error = error
                    strongSelf.queue.cancelAllOperations()
                    Log.error("image upload error: \(error.localizedDescription)")
                }
            })
            queue.addOperation(operation)
            operations.append(operation)
        }
        // 3. Add compeltion code & start execution
        queue.addBarrierBlock {[weak self] in
            guard let strongSelf = self else { return }
            if let error = strongSelf.error {
                strongSelf.completion(.failure(error))
            } else {
                strongSelf.completion(.success(strongSelf.urls))
            }
        }
        queue.isSuspended = false
    }
}
