//
//  ServiceError.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 10/08/2023.
//

import Foundation

enum ServiceError: Error {
    
    case wrongURL
    case undefined
    case containerParsing(String)
    
    case custom(String)
    
    var message: String {
        switch self {
        case .wrongURL:                         return "Wrong URL"
        case .undefined:                        return "Undefined error"
        case let .containerParsing(errorMsg):   return "Container parsing failed - \(errorMsg)"
        case let .custom(errorMsg):             return "Something went wrong - \(errorMsg)"
        }
    }
}
