//
//  DetailsViewController.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 14/08/2023.
//

import UIKit

class DetailsViewController: UIViewController {

    // MARK: Attributes
    
    let viewModel: DetailsViewModel
    
    
    // MARK: Config
    
    init(detailsPrettyString: String) {
        self.viewModel = DetailsViewModel(detailsPrettyString: detailsPrettyString)
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

extension DetailsViewController {
    
    private func setupUI() {
        
        view.backgroundColor = .white
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = viewModel.detailsPrettyString
        scrollView.addSubview(label)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 30),

            label.topAnchor.constraint(equalTo: scrollView.topAnchor),
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            label.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}
