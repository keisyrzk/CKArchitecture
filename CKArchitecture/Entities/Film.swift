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
}

struct FilmContainer: Decodable {
    let count:      Int
    let next:       String?
    let previous:   String?
    let results:    [Film]
}
