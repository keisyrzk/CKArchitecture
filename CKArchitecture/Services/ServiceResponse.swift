//
//  ServiceResponse.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 10/08/2023.
//

import Foundation

// sample custom implemention of a response - similar to built-in `Result`
enum ServiceResponse<T> {
    case success(T)
    case failure(ServiceError)
}
