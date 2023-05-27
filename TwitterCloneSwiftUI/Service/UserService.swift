//
//  UserService.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 27/05/23.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

// MARK: - Service
final class UserService {
    
    let db = Firestore.firestore()
}

// MARK: - Method(s)
extension UserService {
    
    internal func storeUserInformation(userId: String,
                                       data: [String: Any],
                                       completion: @escaping ResultCallback) {
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
}
