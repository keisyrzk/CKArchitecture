//
//  EnumParser.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 14/08/2023.
//

import Foundation

/**
        An alternate parsing approach based on enums.
        Its purpose is to be an exchange to `People`, `Films` and `Planets` `Contianers`
 */

struct GenericContainer: Decodable {
    
    let count:      Int
    let next:       String?
    let previous:   String?
    let results:    GenericContainerResult
}

enum GenericContainerResult: Decodable {
    
    case people([Person])
    case planets([Planet])
    case films([Film])

    init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()

        if let people = try? container.decode([Person].self) {
            self = .people(people)
        }
        else if let planets = try? container.decode([Planet].self) {
            self = .planets(planets)
        }
        else if let films = try? container.decode([Film].self) {
            self = .films(films)
        }
        else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid data for GenericContainerResult"
            )
        }
    }
}
