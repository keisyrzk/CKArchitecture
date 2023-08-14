//
//  MainViewController.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 11/08/2023.
//

import UIKit
import Combine

class MainViewController: BaseViewController {
    
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
                        .eraseToAnyPublisher(),
                didClickPlanetsOption:
                    planetsButton
                        .tapPublisher
                        .eraseToAnyPublisher(),
                didClickFilmsOption:
                    filmsButton
                        .tapPublisher
                        .eraseToAnyPublisher()
            )
        )
        
        output.onError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showAlert(error: error)
            }
            .store(in: &viewModel.cancellables)
        
        output.onPush
            .receive(on: DispatchQueue.main)
            .sink { [weak self] module in
                self?.push(module)
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

extension MainViewController {
    
    private func setupUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(peopleButton)
        view.addSubview(planetsButton)
        view.addSubview(filmsButton)
        setup()
        
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
