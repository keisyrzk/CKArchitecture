//
//  Planet.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 10/08/2023.
//

import Foundation

struct Planet: Decodable {
    let name:   String
    let terrain:    String
    let population: String
    let residents:  [String]
    let films:      [String]
    
    // prints Planet data in a pretty way
    var prettyPrinted: String {
        return [
            name,
            terrain,
            population
        ].joined(separator: "\n")
    }
}

extension Planet {
    
    // get all not-nil uriIds from residnets list
    var residentsIds: [String] {
        return residents.compactMap{ $0.uriId }
    }
    
    // get all not-nil uriIds from films
    var filmsIds: [String] {
        return films.compactMap{ $0.uriId }
    }
}

// extension to an array of Planet objects like [Planet] that prints the components the pretty way
extension Array where Element == Planet {
    
    var prettyPrinted: String {
        return self.map{ $0.prettyPrinted }.joined(separator: "\n")
    }
}

struct PlanetContainer: Decodable {
    let count:      Int
    let next:       String?
    let previous:   String?
    let results:    [Planet]
}
