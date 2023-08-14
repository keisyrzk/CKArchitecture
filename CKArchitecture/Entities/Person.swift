//
//  Person.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 10/08/2023.
//

import Foundation

struct Person: Decodable {
    
    let name:       String
    let height:     String
    let mass:       String
    let gender:     Gender
    let homeworld:  String
    let films:      [String]
    
    var prettyPrinted: String {
        return [
            name,
            height,
            mass,
            gender.rawValue,
            homeworld
        ].joined(separator: "\n")
    }
}

extension Person {
    
    var homeworldId: String? {
        return homeworld.uriId
    }
    
    var filmsIds: [String] {
        return films.compactMap{ $0.uriId }
    }
}

extension Array where Element == Person {
    
    var prettyPrinted: String {
        return self.map{ $0.prettyPrinted }.joined(separator: "\n")
    }
}

struct PeopleContainer: Decodable {
    let count:      Int
    let next:       String?
    let previous:   String?
    let results:    [Person]
}
