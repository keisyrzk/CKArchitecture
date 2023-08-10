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
    
    case custom(String)
}
