//
//  CustomErrors.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 21/04/23.
//

import Foundation

// MARK: - APIError
enum APIError: Error {
    case incorrectURL
    case responseError(statusCode: Int)
    case responseCastError
    case parsingError
}

extension APIError: CustomStringConvertible {
    var description: String {
        switch self {
        case .incorrectURL:
            return "Given URL is incorrect"
        case .responseError(let statusCode):
            return "Received wrong status code: \(statusCode)"
        case .responseCastError:
            return "Couldn't cast to HTTPURLResponse"
        case .parsingError:
            return "Couldn't not parse JSON"
        }
    }
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incorrectURL:
            return "Something went wrong"
        case .responseError(let _):
            return "Something went wrong"
        case .responseCastError:
            return "Something went wrong"
        case .parsingError:
            return "Something went wrong"
        }
    }
}

// MARK: - Register Error
enum RegisterError: Error {
case emptyMetaData
case emptyProfileImageUrl
}

extension RegisterError: CustomStringConvertible {
    var description: String {
        switch self {
        case .emptyMetaData:
            return "Received empty meta date while creating user"
        case .emptyProfileImageUrl:
            return "Received empty empty profile image url while uploading user's profile image"
        }
    }
}
    
extension RegisterError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyMetaData:
            return "Something went wrong"
        case .emptyProfileImageUrl:
            return "Something went wrong"
        }
    }
}

// MARK: - User Profile
enum UserProfileError: Error {
case emptyData
}

extension UserProfileError: CustomStringConvertible {
    var description: String {
        switch self {
        case .emptyData:
            return "Received empty data while fetching profile"
        }
    }
}
    
extension UserProfileError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyData:
            return "Something went wrong"
        }
    }
}


