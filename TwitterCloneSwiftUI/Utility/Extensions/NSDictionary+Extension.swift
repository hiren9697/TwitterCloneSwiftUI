//
//  NSDictionary+Extension.swift
//  ListStructure
//
//  Created by Hiren Faldu Solution on 21/05/22.
//

import Foundation

extension NSDictionary{
    
    func doubleValue(key: String) -> Double{
        if let any = object(forKey: key){
            if let number = any as? NSNumber{
                return number.doubleValue
            }else if let str = any as? NSString{
                return str.doubleValue
            }
        }
        return 0
    }
    
    func floatValue(key: String) -> Float{
        if let any = object(forKey: key){
            if let number = any as? NSNumber{
                return number.floatValue
            }else if let str = any as? NSString{
                return str.floatValue
            }
        }
        return 0
    }
    
    func uintValue(key: String) -> UInt{
        if let any = object(forKey: key){
            if let number = any as? NSNumber{
                return number.uintValue
            }else if let str = any as? NSString{
                return UInt(str.integerValue)
            }
        }
        return 0
    }
    
    func intValue(key: String) -> Int{
        if let any = object(forKey: key){
            if let number = any as? NSNumber{
                return number.intValue
            }else if let str = any as? NSString{
                return str.integerValue
            }
        }
        return 0
    }

    func int32Value(key: String) -> Int32 {
        if let any = object(forKey: key){
            if let number = any as? NSNumber {
                return number.int32Value
            }else if let str = any as? NSString {
                return str.intValue
            }
        }
        return 0
    }
    
    func int16Value(key: String) -> Int16{
        if let any = object(forKey: key){
            if let number = any as? NSNumber{
                return number.int16Value
            }else if let str = any as? NSString{
                return Int16(str.intValue)
            }
        }
        return 0
    }
    
    func stringValue(key: String) -> String{
        if let any = object(forKey: key){
            if let number = any as? NSNumber{
                return number.stringValue
            }else if let str = any as? String{
                return str
            }
        }
        return ""
    }
    
    func optionalStringValue(key: String)-> String? {
        if let any = object(forKey: key){
            if let number = any as? NSNumber{
                return number.stringValue
            }else if let str = any as? String{
                return str
            }
        }
        return nil
    }
    
    func booleanValue(key: String) -> Bool {
        if let any = object(forKey: key) {
            if let num = any as? NSNumber {
                return num.boolValue
            } else if let str = any as? NSString {
                return str.boolValue
            }
        }
        return false
    }
    
    func optionalBooleanValue(key: String) -> Bool? {
        if let any = object(forKey: key) {
            if let num = any as? NSNumber {
                return num.boolValue
            } else if let str = any as? NSString {
                return str.boolValue
            }
        }
        return nil
    }
    
    func optionalFloatValue(key: String) -> Float? {
        if let any = object(forKey: key){
            if let number = any as? NSNumber{
                return number.floatValue
            }else if let str = any as? NSString{
                return str.floatValue
            }
        }
        return nil
    }
    
    func dictionaryValue(key: String)-> NSDictionary {
        if let any = object(forKey: key) {
            if let dictionary = any as? NSDictionary {
                return dictionary
            } else {
                return [:]
            }
        } else {
            return [:]
        }
    }
    
    func optionalDictionaryValue(key: String)-> NSDictionary? {
        return object(forKey: key) as? NSDictionary
    }
    
    func arrayOfDictionary(key: String)-> [NSDictionary] {
        return object(forKey: key) as? [NSDictionary] ?? []
    }
    
    func optionalArrayOfDictionary(key: String)-> [NSDictionary]? {
        return object(forKey: key) as? [NSDictionary]
    }
}
