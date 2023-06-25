//
//  TweetService.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 25/06/23.
//

import SwiftUI
import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

// MARK: - Service
final class TweetService {
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    let mediaUploadQueue = OperationQueue()
}

// MARK: - Register method(s)
extension TweetService {
    internal func uploadTweet(userId: String,
                              tweetText: String,
                              images: [UIImage],
                              videos: [URL],
                              completion: @escaping ResultVoidCallback) {
        mediaUploadQueue.isSuspended = true
        mediaUploadQueue.qualityOfService = .background
        var imageURLs: [URL] = []
        let mediaUploadOperation = MediaUploadOperation(images: images,
                                                        videos: videos,
                                                        completion: {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let urls):
                Log.info("Image URLs: \(urls)")
                completion(.success(()))
            case .failure(let error):
                Log.error("Error in image upload: \(error.localizedDescription)")
            }
        })
        mediaUploadOperation.start()
        //        mediaUploadQueue.addBarrierBlock {[weak self] in
        //            guard let strongSelf = self else { return }
        //            let id = strongSelf.db.collection(DatabaseCollection.tweets.rawValue).document().documentID
        //            let data: [String: Any] = [
        //                "id": id,
        //                "user_id": userId,
        //                "tweet_text": tweetText,
        //                "images":
        //            ]
        //            strongSelf.db.collection(DatabaseCollection.tweets.rawValue)
        //                .document(id)
        //                .setData(data) { error in
        //                    if let error = error {
        //                        completion(.failure(error))
        //                        return
        //                    }
        //                    completion(.success(()))
        //                }
        //        }
    }
}


