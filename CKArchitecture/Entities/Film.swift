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
    
    var charactersIds: [String] {
        return characters.compactMap{ $0.uriId }
    }
    
    var planetsIds: [String] {
        return planets.compactMap{ $0.uriId }
    }
}

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
