//
//  Services.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 10/08/2023.
//

import Combine
import Foundation

let services = Services()

class Services {
    
    let people = PeopleServices()
    let film = FilmServices()
    let planet = PlanetServices()
        
}

extension Services {
    
    func request<T: Decodable>(_ service: ServiceCategory) -> Future<T, ServiceError> {
        
        let baseURL = "https://swapi.dev/api"
        
        return Future { promise in

            guard let url = URL(string: baseURL + service.categoryStringUrl + service.requestEndpoint) else {
                promise(.failure(.wrongURL))
                return
            }

            Task {
                do {
                    let data = try await URLSession.shared.data(from: url).0
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    promise(.success(decodedData))
                } catch {
                    promise(.failure(.custom(error.localizedDescription)))
                }
            }
        }
    }
}
