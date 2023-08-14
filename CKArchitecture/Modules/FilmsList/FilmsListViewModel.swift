//
//  FilmsListViewModel.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 14/08/2023.
//

import Combine

class FilmsListViewModel {
    
    let films: [Film]
    
    init(films: [Film]) {
        self.films = films
    }
    
    
    // MARK: Input / Output
    
    struct Input {
        let selectedFilm:    AnyPublisher<Film, Never>
    }
    
    struct Output {
        let onError:                AnyPublisher<ServiceError, Never>
        let onIsSpinnerPresented:   AnyPublisher<Bool, Never>
        let onShow:                 AnyPublisher<Module, Never>
    }
    
    // MARK: Publishers
    
    var cancellables = Set<AnyCancellable>()
    private let errorPublisher = PassthroughSubject<ServiceError, Never>()
    private let onIsSpinnerPresentedPublisher = PassthroughSubject<Bool, Never>()
    private var onShow = PassthroughSubject<Module, Never>()
    
    private let onCharacters = PassthroughSubject<[Person], Never>()
    private var onPlanets = PassthroughSubject<[Planet], Never>()
    
    
    // MARK: Transform
    
    func transform(_ input: Input) -> Output {
        
        errorPublisher
            .sink { [weak self] _ in
                self?.onIsSpinnerPresentedPublisher.send(false)
            }
            .store(in: &cancellables)
        
        input.selectedFilm
            .sink { [weak self] films in
                self?.onIsSpinnerPresentedPublisher.send(true)
                self?.getCharacters(ids: films.charactersIds)
                self?.getPlanets(ids: films.planetsIds)
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest(onCharacters, onPlanets)
            .sink { [weak self] (characters, planets) in
                self?.onIsSpinnerPresentedPublisher.send(false)
                self?.showDetails([
                    characters.prettyPrinted,
                    planets.prettyPrinted
                ])
            }
            .store(in: &cancellables)
        
        return Output(
            onError:                errorPublisher.eraseToAnyPublisher(),
            onIsSpinnerPresented:   onIsSpinnerPresentedPublisher.eraseToAnyPublisher(),
            onShow:                 onShow.eraseToAnyPublisher()
        )
    }
}

//MARK: Interactor
extension FilmsListViewModel {
    
    private func getCharacters(ids: [String]) {
        guard ids.count > 0 else {
            onCharacters.send([])
            return
        }
        
        var residents: [Person] = []
        
        ids.forEach { id in
            services.people.getPerson(id: id)
                .sink { [unowned self] result in
                    if case let .failure(error) = result {
                        errorPublisher.send(error)
                    }
                } receiveValue: { [unowned self] person in
                    residents.append(person)
                    if residents.count == ids.count {
                        onCharacters.send(residents)
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    private func getPlanets(ids: [String]) {
        guard ids.count > 0 else {
            onPlanets.send([])
            return
        }
        
        var planets: [Planet] = []
        
        ids.forEach { id in
            services.planet.getPlanet(id: id)
                .sink { [unowned self] result in
                    if case let .failure(error) = result {
                        errorPublisher.send(error)
                    }
                } receiveValue: { [unowned self] planet in
                    planets.append(planet)
                    if planets.count == ids.count {
                        onPlanets.send(planets)
                    }
                }
                .store(in: &cancellables)
        }
    }
}

//MARK: Router
extension FilmsListViewModel {
    
    private func showDetails(_ prettyStrings: [String]) {
        onShow.send(.details(prettyStrings.joined(separator: "\n")))
    }
}
