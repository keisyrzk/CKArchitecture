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
    
}

struct PeopleContainer: Decodable {
    let count:      Int
    let next:       String?
    let previous:   String?
    let results:    [Person]
}
