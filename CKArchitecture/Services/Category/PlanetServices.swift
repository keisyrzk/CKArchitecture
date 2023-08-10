//
//  PlanetServices.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 10/08/2023.
//

import Combine

enum PlanetServicesType: Service {
    
    case getAll
    case getPlanet(id: String)
    
    var endpoint: String {
        switch self {
        case .getAll:               return "/planets"
        case let .getPlanet(id):    return "/planets/\(id)"
        }
    }
}

struct PlanetServices {
    
    func getAll() -> AnyPublisher<[Planet], ServiceError> {
        return services.request(.planet(.getAll)).eraseToAnyPublisher()
    }
    
    func getPlanet(id: String) -> AnyPublisher<Planet, ServiceError> {
        return services.request(.planet(.getPlanet(id: id))).eraseToAnyPublisher()
    }
}
