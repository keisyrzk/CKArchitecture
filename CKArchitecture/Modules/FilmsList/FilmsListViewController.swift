//
//  FilmsListViewController.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 14/08/2023.
//

import UIKit

class FilmsListViewController: BaseViewController {

    // MARK: Attributes
    
    private let viewModel: FilmsListViewModel
    
    lazy var tableView: CKTableView = {
        let tableView = CKTableView(items: viewModel.films)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    // MARK: Config
    
    init(films: [Film]) {
        viewModel = FilmsListViewModel(films: films)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        binding()
    }
    
    private func binding() {
        
        // run the events transform function
        let output = viewModel.transform(
            // the compiler knows from the context that it will be the `Person` so no type check is needed
            FilmsListViewModel.Input(
                selectedFilm:
                    tableView.onCellClickPublisher.eraseToAnyPublisher()
            )
        )
        
        // subscribe to events
        output.onShow
            .receive(on: DispatchQueue.main)
            .sink { [weak self] module in
                self?.show(module)
            }
            .store(in: &viewModel.cancellables)
        
        output.onError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showAlert(error: error)
            }
            .store(in: &viewModel.cancellables)
        
        output.onIsSpinnerPresented
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPresented in
                self?.showSpinner(isPresented)
            }
            .store(in: &viewModel.cancellables)
    }
}


//MARK: UI

extension FilmsListViewController {
    
    private func setupUI() {
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        setup()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
