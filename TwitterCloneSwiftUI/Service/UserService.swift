//
//  UserService.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 27/05/23.
//

import SwiftUI
import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

// MARK: - Service
final class UserService {
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
}

// MARK: - Register method(s)
extension UserService {
    
    internal func storeUserInformation(userId: String,
                                       data: [String: Any],
                                       completion: @escaping ResultVoidCallback) {
        db.collection(DatabaseCollection.users.rawValue)
            .document(userId)
            .setData(data) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
    }
    
    internal func storeProfileImage(image: UIImage,
                                    completion: @escaping ResultURLCallback) {
        // 1. Create child reference
        let reference = storage.child("\(DatabaseStorage.profile.rawValue)/\(getTimeStamp()).jpg")
        // 2. Convert image to data
        guard let data = image.jpegData(compressionQuality: 0.3) else {
            return
        }
        // 3. Upload data
        reference.putData(data) {[weak self] metadata, error in
            guard let _ = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            // 4. Download url
            reference.downloadURL {[weak self] url, error in
                guard let _ = self else { return }
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let url = url {
                    completion(.success(url))
                } else {
                    completion(.failure(RegisterError.emptyProfileImageUrl))
                }
            }
        }
    }
}

// MARK: - Profile method(s)
extension UserService {
    
    func fetchProfile(completion: @escaping (Result<User, Error>)-> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        db.collection(DatabaseCollection.users.rawValue)
            .document(uid)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                } else if let data = snapshot?.data() {
                    let dictionary = data as NSDictionary
                    let user = User(dictionary: dictionary)
                    completion(.success(user))
                } else {
                    completion(.failure(UserProfileError.emptyData))
                }
            }
    }
}
