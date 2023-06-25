//
//  Common.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 20/05/23.
//

import Foundation

// MARK: - CallBack Typealis
typealias VoidCallback = ()-> Void
typealias StringCallback = ()-> Void
typealias IntCallback = ()-> Void
typealias ResultVoidCallback = (Result<Void, Error>)-> Void
typealias ResultURLCallback = (Result<URL, Error>)-> Void
typealias ResultURLsCallback = (Result<[URL], Error>)-> Void

