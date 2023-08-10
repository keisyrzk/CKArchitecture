//
//  PeopleServices.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 10/08/2023.
//

import Combine
import Foundation

enum PeopleServicesType: Service {
    
    case getAll
    case getPerson(id: String)
    
    var endpoint: String {
        switch self {
        case .getAll:               return "/people"
        case let .getPerson(id):    return "/people/\(id)"
        }
    }
}

struct PeopleServices {
    
    func getAll() -> AnyPublisher<[Person], ServiceError> {
        return services.request(.people(.getAll)).eraseToAnyPublisher()
    }
    
    func getPerson(id: String) -> AnyPublisher<Person, ServiceError> {
        return services.request(.people(.getPerson(id: id))).eraseToAnyPublisher()
    }
}
