//
//  ServiceCategory.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 10/08/2023.
//

import Foundation

enum ServiceCategory {
    
    case people (PeopleServicesType)
    case film   (FilmServicesType)
    case planet (PlanetServicesType)
    
    var categoryStringUrl: String {
        switch self {
        case .people:   return "/people"
        case .film:     return "/film"
        case .planet:   return "/planet"
        }
    }
    
    var requestEndpoint: String {
        switch self {
        case let .people(service):  return service.endpoint
        case let .film(service):    return service.endpoint
        case let .planet(service):  return service.endpoint
        }
    }
}
