//
//  ServiceResponse.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 10/08/2023.
//

import Foundation

enum ServiceResponse<T> {
    case success(T)
    case failure(ServiceError)
}
