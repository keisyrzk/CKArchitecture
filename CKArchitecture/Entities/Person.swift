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
    
    // prints Person data in a pretty way
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
    
    // get uriId from the `homeworld` String (it is an url string)
    var homeworldId: String? {
        return homeworld.uriId
    }
    
    // get all not-nil uriIds from films
    var filmsIds: [String] {
        return films.compactMap{ $0.uriId }
    }
}

// extension to an array of Person objects like [Person] that prints the components the pretty way
extension Array where Element == Person {
    
    var prettyPrinted: String {
        return self.map{ $0.prettyPrinted }.joined(separator: "\n")
    }
}

// data container when requesting for people list
struct PeopleContainer: Decodable {
    let count:      Int
    let next:       String?
    let previous:   String?
    let results:    [Person]
}
