//
//  FilmServices.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 10/08/2023.
//

import Combine

enum FilmServicesType: Service {
    
    case getAll
    case getFilm(id: String)
    
    var endpoint: String {
        switch self {
        case .getAll:               return "/films"
        case let .getFilm(id):      return "/films/\(id)"
        }
    }
}

struct FilmServices {
    
    func getAll() -> AnyPublisher<[Film], ServiceError> {
        return services.request(.film(.getAll)).eraseToAnyPublisher()
    }
    
    func getFilm(id: String) -> AnyPublisher<Film, ServiceError> {
        return services.request(.film(.getFilm(id: id))).eraseToAnyPublisher()
    }
}
