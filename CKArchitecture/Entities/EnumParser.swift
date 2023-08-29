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

/**
    
 In Swift's Decodable, singleValueContainer() is just one of the methods provided to assist in custom parsing of the data. Essentially, Decodable lets you interact with three types of container:

 Single Value Container: It allows the decoder to decode a single value at the current decoding location.

 Keyed Container: It decodes a dictionary where you can decode values based on their associated keys.

 Unkeyed Container: It decodes an array of values sequentially.
 
 
 
 `Example: Keyed Container`
 
 enum GenericContainerResult: Decodable {
     
     case people([Person])
     case planets([Planet])
     case films([Film])

     enum CodingKeys: String, CodingKey {
         case people
         case planets
         case films
     }

     init(from decoder: Decoder) throws {
         
         let container = try decoder.container(keyedBy: CodingKeys.self)

         if let people = try? container.decode([Person].self, forKey: .people) {
             self = .people(people)
         }
         else if let planets = try? container.decode([Planet].self, forKey: .planets) {
             self = .planets(planets)
         }
         else if let films = try? container.decode([Film].self, forKey: .films) {
             self = .films(films)
         }
         else {
             throw DecodingError.dataCorrupted(
                 DecodingError.Context(
                     codingPath: container.codingPath,
                     debugDescription: "Invalid data for GenericContainerResult"
                 )
             )
         }
     }
 }

 
 However, do note that this change would necessitate a modification to your JSON structure. Each of the arrays (people, planets, and films) would need to be nested under their respective key:
 {
     "count": 2,
     "next": "https://nextPage.com",
     "previous": null,
     "people": [
         {
             "name": "Obi Wan Kenobi",
             "height": "180",
             "mass": "80",
             "gender": "male"
         },
         {
             "name": "Anakin Skywalker",
             "height": "178",
             "mass": "75",
             "gender": "male"
         }
     ]
 }

 
    `Example: UnkeyedContainer
 An UnkeyedContainer in Swift's Decodable is essentially for dealing with arrays or lists of values. It allows you to sequentially decode values without needing to know a specific key for each value.

 Let's take an example: Imagine you have a JSON where sometimes the results key contains an array of mixed data types (i.e., a mix of people, planets, and films). This is an unconventional approach and generally not recommended, but for the sake of demonstration, let's see how an UnkeyedContainer would be used in this case:
 
 {
     "count": 3,
     "next": "https://nextPage.com",
     "previous": null,
     "results": [
         {
             "type": "person",
             "name": "Obi Wan Kenobi",
             "height": "180",
             "mass": "80",
             "gender": "male"
         },
         {
             "type": "planet",
             "name": "Tatooine",
             "terrain": "desert",
             "population": "20000000"
         },
         {
             "type": "film",
             "title": "The Revenge of The Sith",
             "episode_id": 3
         }
     ]
 }

 
 
 Here, each item in the array has a type key indicating what kind of data it represents.
 
 struct GenericContainer: Decodable {
     
     let count: Int
     let next: String?
     let previous: String?
     let results: [GenericContainerResult]
 }

 enum GenericContainerResult: Decodable {
     
     case person(Person)
     case planet(Planet)
     case film(Film)
     
     private enum ResultType: String, Decodable {
         case person, planet, film
     }

     init(from decoder: Decoder) throws {
         var container = try decoder.unkeyedContainer()
         let nestedDecoder = try container.superDecoder()
         let typeContainer = try nestedDecoder.container(keyedBy: CodingKeys.self)
         let type = try typeContainer.decode(ResultType.self, forKey: .type)
         
         switch type {
         case .person:
             let person = try Person(from: nestedDecoder)
             self = .person(person)
         case .planet:
             let planet = try Planet(from: nestedDecoder)
             self = .planet(planet)
         case .film:
             let film = try Film(from: nestedDecoder)
             self = .film(film)
         }
     }
     
     private enum CodingKeys: String, CodingKey {
         case type
     }
 }

 In this code, the UnkeyedContainer is used to iterate over each item in the results array. For each item, we determine the type and then decode the corresponding data structure.
 
 `
 
 */

