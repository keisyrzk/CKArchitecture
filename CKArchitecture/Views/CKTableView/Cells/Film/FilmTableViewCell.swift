//
//  FilmTableViewCell.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 14/08/2023.
//

import UIKit

class FilmTableViewCell: UITableViewCell, TypedConfigurableCell {

    @IBOutlet weak var stackView: UIStackView!
    
    static let identifier = "Film"

    func configure(item: Film) {
        selectionStyle = .none
        
        for arrangedSubview in stackView.arrangedSubviews {
            // Remove any existing arranged subviews to reset the cell
            stackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "Title: \(item.title)"
        
        let heightLabel = UILabel()
        heightLabel.text = "Terrain: \(item.director)"
                
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(heightLabel)
    }
    
    func configureAny(item: Any) {
        if let data = item as? Film {
            configure(item: data)
        }
    }
}
