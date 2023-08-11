//
//  MainViewController.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 11/08/2023.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    //MARK: Attributes
    
    private let viewModel = MainViewModel()
    
    lazy var peopleButton: UIButton = {
        return MainButtonType.people.button
    }()
    
    lazy var planetsButton: UIButton = {
        return MainButtonType.planets.button
    }()
    
    lazy var filmsButton: UIButton = {
        return MainButtonType.films.button
    }()
        
    // MARK: Config
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        binding()
    }
    
    
    // MARK: Binding
    
    private func binding() {
        
        let output = viewModel.transform(
            MainViewModel.Input(
                didClickPeopleOption:
                    peopleButton
                        .tapPublisher
                        .debounce(for: 3, scheduler: DispatchQueue.main)
                        .eraseToAnyPublisher(),
                didClickPlanetsOption:
                    planetsButton
                        .tapPublisher
                        .debounce(for: 3, scheduler: DispatchQueue.main)
                        .eraseToAnyPublisher(),
                didClickFilmsOption:
                    filmsButton
                        .tapPublisher
                        .debounce(for: 3, scheduler: DispatchQueue.main)
                        .eraseToAnyPublisher()
            )
        )
        
        output.onError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showAlert(error: error)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func showAlert(error: ServiceError) {
            let alert = UIAlertController(title: "Error",
                                          message: error.message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
}

//MARK: UI

extension MainViewController {
    
    func setupUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(peopleButton)
        view.addSubview(planetsButton)
        view.addSubview(filmsButton)
        
        NSLayoutConstraint.activate([
            peopleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            peopleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            peopleButton.widthAnchor.constraint(equalToConstant: 100),
            peopleButton.heightAnchor.constraint(equalToConstant: 40),
            planetsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            planetsButton.topAnchor.constraint(equalTo: peopleButton.bottomAnchor, constant: 50),
            planetsButton.widthAnchor.constraint(equalToConstant: 100),
            planetsButton.heightAnchor.constraint(equalToConstant: 40),
            filmsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filmsButton.topAnchor.constraint(equalTo: planetsButton.bottomAnchor, constant: 50),
            filmsButton.widthAnchor.constraint(equalToConstant: 100),
            filmsButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
