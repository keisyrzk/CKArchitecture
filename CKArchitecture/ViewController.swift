//
//  ViewController.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 10/08/2023.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        services.planet.getAll()
            .sink { response in
                switch response {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { planets in
                print(planets)
            }
            .store(in: &cancellables)


    }


}

