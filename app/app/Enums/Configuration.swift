//
//  Configuration.swift
//  app
//
//  Created by kelly on 2020/02/21.
//  Copyright © 2020 kelly. All rights reserved.
//

import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey
        case invalidValue
    }
    
    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }
        
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

enum API {
    static var baseURL: URL {
        return URL(string: "https://" + (try! Configuration.value(for: "API_BASE_URL")))!
    }
    
    static var key: String {
        return try! Configuration.value(for: "API_KEY")
    }
}
