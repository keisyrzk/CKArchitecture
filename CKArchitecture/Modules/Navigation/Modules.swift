//
//  Modules.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 14/08/2023.
//

import UIKit

enum Module: Hashable {
    
    static func == (lhs: Module, rhs: Module) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    case main
    case peopleList     ([Person])
    case planetsList    ([Planet])
    case filmsList      ([Film])
//    case personDetails  (Person)
//    case planetDetails  (Planet)
//    case filmDetails    (Film)
    
    var id: String {
        switch self {
        case .main:             return "main"
        case .peopleList:       return "peopleList"
        case .planetsList:      return "planetsList"
        case .filmsList:        return "filmsList"
//        case .personDetails:    return "personDetails"
//        case .planetDetails:    return "planetDetails"
//        case .filmDetails:      return "filmDetails"
        }
    }
    
    var view: UIViewController {
        switch self {
        case .main:                     return MainViewController()
        case let .peopleList(people):   return PeopleListViewController(people: people)
        case let .planetsList(planets): return PlanetsListViewController(planets: planets)
        case let .filmsList(films):     return FilmsListViewController(films: films)
        }
    }
}

extension Module {
    
    static func embedNavigation(_ module: Module, in window: UIWindow) {
        
        let navigator = UINavigationController()
        navigator.viewControllers = [module.view]
        
        window.rootViewController = navigator
        window.makeKeyAndVisible()
    }
}

