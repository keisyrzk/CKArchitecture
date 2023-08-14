//
//  PersonTableViewCell.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 14/08/2023.
//

import UIKit

class PersonTableViewCell: UITableViewCell, TypedConfigurableCell {
    
    @IBOutlet weak var stackView: UIStackView!
    
    static let identifier = "Person"

    func configure(item: Person) {
        selectionStyle = .none
        
        for arrangedSubview in stackView.arrangedSubviews {
            // Remove any existing arranged subviews to reset the cell
            stackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
        
        let nameLabel = UILabel()
        nameLabel.text = "Name: \(item.name)"
        
        let heightLabel = UILabel()
        heightLabel.text = "Height: \(item.height)"
                
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(heightLabel)
    }
    
    func configureAny(item: Any) {
        if let data = item as? Person {
            configure(item: data)
        }
    }
}

