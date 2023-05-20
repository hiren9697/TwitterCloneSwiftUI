//
//  Log.swift
//  Twitter
//
//  Created by Hiren Faldu Solution on 23/06/22.
//

import UIKit

enum Log {

    enum Level {
        case info
        case apiRequest
        case apiResponse
        case warning
        case success
        case error
        case deallocate
        
        fileprivate var symbole: String {
            switch self {
            case .info: return "ℹ️"
            case .apiRequest: return "↖︎"
            case .apiResponse: return "↘︎"
            case .warning: return "⚠️"
            case .success: return "✅"
            case .error: return "🛑"
            case .deallocate: return "🔥"
            }
        }
    }
    
    struct Context {
        let file: String
        let function: String
        let line: Int
        var description: String {
            return "\((file as NSString).lastPathComponent): \(line) \(function)"
        }
    }
    
    fileprivate static func handleLog (
        level: Level,
        content: Any...,
        shouldLogContext: Bool,
        context: Context
    ) {
        
        #if DEBUG
        // If content is single string line, then print in single line
        if content.count == 1,
           let stringContent = content.first as? String,
           !stringContent.contains("\n") {
            print("\n DEBUG \(level.symbole) \(content) \(context.description) \(level.symbole) \n")
        } else {
        // Else print eacth item in single line
            print("DEBUG \n[ \(level.symbole)")
            for item in content {
                print(item)
            }
            print("📁 \(context.description)")
            print("\(level.symbole) ]\n")
        }
        #endif
    }
}

// MARK: - Print method(s)
extension Log {
    
    public static func info(
        _ content: Any...,
        shouldLogContext: Bool = true,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let context = Context(file: file,
                              function: function,
                              line: line)
        Log.handleLog(level: .info,
                      content: content,
                      shouldLogContext: shouldLogContext,
                      context: context)
    }
    
    public static func apiRequest(
        _ content: Any...,
        shouldLogContext: Bool = true,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let context = Context(file: file,
                              function: function,
                              line: line)
        Log.handleLog(level: .apiRequest,
                      content: content,
                      shouldLogContext: shouldLogContext,
                      context: context)
    }
    
    public static func apiResponse(
        _ content: Any...,
        shouldLogContext: Bool = true,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let context = Context(file: file,
                              function: function,
                              line: line)
        Log.handleLog(level: .apiResponse,
                      content: content,
                      shouldLogContext: shouldLogContext,
                      context: context)
    }
    
    public static func warning(
        _ content: Any...,
        shouldLogContext: Bool = true,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let context = Context(file: file,
                              function: function,
                              line: line)
        Log.handleLog(level: .warning,
                      content: content,
                      shouldLogContext: shouldLogContext,
                      context: context)
    }
    
    public static func success(
        _ content: Any...,
        shouldLogContext: Bool = true,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let context = Context(file: file,
                              function: function,
                              line: line)
        Log.handleLog(level: .success,
                      content: content,
                      shouldLogContext: shouldLogContext,
                      context: context)
    }
    
    public static func error(
        _ content: Any...,
        shouldLogContext: Bool = true,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let context = Context(file: file,
                              function: function,
                              line: line)
        Log.handleLog(level: .error,
                      content: content,
                      shouldLogContext: shouldLogContext,
                      context: context)
    }
    
    public static func deallocate(
        _ content: Any...,
        shouldLogContext: Bool = true,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let context = Context(file: file,
                              function: function,
                              line: line)
        Log.handleLog(level: .deallocate,
                      content: content,
                      shouldLogContext: shouldLogContext,
                      context: context)
    }
}

