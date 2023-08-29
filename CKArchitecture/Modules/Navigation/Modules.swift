//
//  Modules.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 14/08/2023.
//

import UIKit

enum Module: Hashable {
    
    // definition of how the modules should be compared in a manner of being unique
    static func == (lhs: Module, rhs: Module) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // list of modules ("screens") with data needed to pass
    case main
    case peopleList     ([Person])
    case planetsList    ([Planet])
    case filmsList      ([Film])
    case details        (String)
    
    // each module's id
    var id: String {
        switch self {
        case .main:             return "main"
        case .peopleList:       return "peopleList"
        case .planetsList:      return "planetsList"
        case .filmsList:        return "filmsList"
        case .details:          return "details"
        }
    }
    
    // each module's View Controller object
    var view: UIViewController {
        switch self {
        case .main:                             return MainViewController()
        case let .peopleList(people):           return PeopleListViewController(people: people)
        case let .planetsList(planets):         return PlanetsListViewController(planets: planets)
        case let .filmsList(films):             return FilmsListViewController(films: films)
        case let .details(detailsPrettyString): return DetailsViewController(detailsPrettyString: detailsPrettyString)
        }
    }
}

extension Module {
    
    // embed a given module into Navigation Controller to start a navigation stack from this module
    static func embedNavigation(_ module: Module, in window: UIWindow) {
        
        let navigator = UINavigationController()
        navigator.viewControllers = [module.view]
        
        window.rootViewController = navigator
        window.makeKeyAndVisible()
    }
}

