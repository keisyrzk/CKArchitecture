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
    
    // list of API's categories/services
    let people  = PeopleServices()
    let film    = FilmServices()
    let planet  = PlanetServices()
        
}

extension Services {
    
    /*
     generic function that actually fetches data from API based on given
     - baseURL
     - category
     - associated parameters
     
     the function returns
     - publisher (specified with `Future` in this case) that emits fetched data (of type the compiler gets from the context)
     - eventual error mapped to custom `ServiceError`
     
     */
    func request<T: Decodable>(_ service: ServiceCategory) -> Future<T, ServiceError> {
        
        let baseURL = "https://swapi.dev/api"
        
        return Future { promise in

            guard let url = URL(string: baseURL + service.requestEndpoint) else {
                promise(.failure(.wrongURL))
                return
            }

            // handle async API request
            Task {
                do {
                    let data = try await URLSession.shared.data(from: url).0
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    // notify about succeeded data decoding
                    promise(.success(decodedData))
                } catch {
                    // throw the error caught on `try await URLSession.shared.data(from: url).0`
                    promise(.failure(.custom(error.localizedDescription)))
                }
            }
        }
    }
}
