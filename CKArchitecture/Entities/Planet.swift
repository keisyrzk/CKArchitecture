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
}

struct PlanetContainer: Decodable {
    let count:      Int
    let next:       String?
    let previous:   String?
    let results:    [Planet]
}
