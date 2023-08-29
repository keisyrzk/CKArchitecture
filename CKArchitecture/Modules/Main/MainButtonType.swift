//
//  MainButtonType.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 11/08/2023.
//

import UIKit

enum MainButtonType {
    
    case people
    case planets
    case films
    
    var title: String {
        switch self {
        case .people:   return "People"
        case .planets:  return "Planets"
        case .films:    return "Films"
        }
    }
    
    // usage:
    // let filmsButton = MainButtonType.films.button
    var button: UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.purple, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.borderColor = UIColor.purple.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        return button
    }
}
