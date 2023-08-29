//
//  Film.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 10/08/2023.
//

import Foundation

struct Film: Decodable {
    
    let title:          String
    let episode_id:     Int
    let opening_crawl:  String
    let director:       String
    let release_date:   String
    let characters:     [String]
    let planets:        [String]
    
    // prints Film data in a pretty way
    var prettyPrinted: String {
        return [
            title,
            "\(episode_id)",
            opening_crawl,
            director,
            release_date
        ].joined(separator: "\n")
    }
}

extension Film {
    
    // get all not-nil uriIds from characters list
    var charactersIds: [String] {
        return characters.compactMap{ $0.uriId }
    }
    
    // get all not-nil uriIds from films
    var planetsIds: [String] {
        return planets.compactMap{ $0.uriId }
    }
}

// extension to an array of Film objects like [Film] that prints the components the pretty way
extension Array where Element == Film {
    
    var prettyPrinted: String {
        return self.map{ $0.prettyPrinted }.joined(separator: "\n")
    }
}

struct FilmContainer: Decodable {
    let count:      Int
    let next:       String?
    let previous:   String?
    let results:    [Film]
}
