//
//  File.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 27/05/23.
//

import Foundation

struct User: Equatable, Codable {
    let id: String
    let email: String
    let fullname: String
    let username: String
    let profileImageURLString: String
    var profileImageURL: URL? {
        URL(string: profileImageURLString)
    }
    
    init(dictionary: NSDictionary) {
        id = dictionary.stringValue(key: "id")
        email = dictionary.stringValue(key: "email")
        fullname = dictionary.stringValue(key: "fullname")
        username = dictionary.stringValue(key: "username")
        profileImageURLString = dictionary.stringValue(key: "profileImage")
    }
}
