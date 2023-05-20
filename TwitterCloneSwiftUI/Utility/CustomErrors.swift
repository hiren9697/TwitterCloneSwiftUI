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

