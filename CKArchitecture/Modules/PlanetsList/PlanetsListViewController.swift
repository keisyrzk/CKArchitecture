//
//  PlanetsListViewController.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 14/08/2023.
//

import UIKit

class PlanetsListViewController: UIViewController {

    // MARK: Attributes
    
    private let viewModel: PlanetsListViewModel
    
    lazy var tableView: CKTableView = {
        let tableView = CKTableView(items: viewModel.planets)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    // MARK: Config
    
    init(planets: [Planet]) {
        viewModel = PlanetsListViewModel(planets: planets)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}


//MARK: UI

extension PlanetsListViewController {
    
    private func setupUI() {
        
        view.backgroundColor = .white
        view.addSubview(tableView)
                
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
