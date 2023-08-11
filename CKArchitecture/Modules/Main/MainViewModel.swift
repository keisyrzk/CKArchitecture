//
//  MainViewModel.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 11/08/2023.
//

import Combine

class MainViewModel {
    
    // MARK: Input / Output
    
    struct Input {
        let didClickPeopleOption:       AnyPublisher<Void, Never>
        let didClickPlanetsOption:      AnyPublisher<Void, Never>
        let didClickFilmsOption:        AnyPublisher<Void, Never>
    }
    
    struct Output {
        let onError:                AnyPublisher<ServiceError, Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: Transform
    
    func transform(_ input: Input) -> Output {
        
        let errorPublisher = PassthroughSubject<ServiceError, Never>()
        
        // fetch data accordingly
        input.didClickPeopleOption
            .sink { [unowned self] _ in
                getPeople()
                    .sink { response in
                        if case let .failure(error) = response {
                            errorPublisher.send(error)
                        }
                    } receiveValue: { [weak self] people in
                        self?.showPeopleDetails(people)
                    }
                    .store(in: &cancellables)
            }
            .store(in: &cancellables)
        
        input.didClickPlanetsOption
            .sink { [unowned self] _ in
                getPlanets()
                    .sink { response in
                        if case let .failure(error) = response {
                            errorPublisher.send(error)
                        }
                    } receiveValue: { [weak self] planets in
                        self?.showPlanetsDetails(planets)
                    }
                    .store(in: &cancellables)
            }
            .store(in: &cancellables)
        
        input.didClickFilmsOption
            .sink { [unowned self] _ in
                getFilms()
                    .sink { response in
                        if case let .failure(error) = response {
                            errorPublisher.send(error)
                        }
                    } receiveValue: { [weak self] films in
                        self?.showFilmDetails(films)
                    }
                    .store(in: &cancellables)
            }
            .store(in: &cancellables)
        
        
        return Output(
            onError: errorPublisher.eraseToAnyPublisher()
        )
    }
}

//MARK: Interactor
extension MainViewModel {
    
    private func getPeople() -> AnyPublisher<[Person], ServiceError> {
        return services.people.getAll()
    }
    
    private func getPlanets() -> AnyPublisher<[Planet], ServiceError> {
        return services.planet.getAll()
    }
    
    private func getFilms() -> AnyPublisher<[Film], ServiceError> {
        return services.film.getAll()
    }
}

//MARK: Router
extension MainViewModel {
    
    private func showPeopleDetails(_ people: [Person]) {
        print("Show details for people: \(people.count)")
    }
    
    private func showPlanetsDetails(_ planets: [Planet]) {
        print("Show details for planets: \(planets.count)")
    }
    
    private func showFilmDetails(_ films: [Film]) {
        print("Show details for films: \(films.count)")
    }
}
