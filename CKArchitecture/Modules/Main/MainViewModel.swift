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
        let onIsSpinnerPresented:   AnyPublisher<Bool, Never>
        let onPush:                 AnyPublisher<Module, Never>
    }
    
    
    // MARK: Publishers
    
    var cancellables = Set<AnyCancellable>()
    private let errorPublisher = PassthroughSubject<ServiceError, Never>()
    private let onIsSpinnerPresentedPublisher = PassthroughSubject<Bool, Never>()
    private var onPush = PassthroughSubject<Module, Never>()
    
    
    // MARK: Transform
    
    func transform(_ input: Input) -> Output {
        
        errorPublisher
            .sink { [weak self] _ in
                self?.onIsSpinnerPresentedPublisher.send(false)
            }
            .store(in: &cancellables)
        
        // fetch data accordingly
        input.didClickPeopleOption
            .sink { [unowned self] _ in
                onIsSpinnerPresentedPublisher.send(true)
                getPeople()
                    .sink { [weak self] response in
                        if case let .failure(error) = response {
                            self?.errorPublisher.send(error)
                        }
                    } receiveValue: { [weak self] people in
                        self?.showPeopleDetails(people)
                    }
                    .store(in: &cancellables)
            }
            .store(in: &cancellables)
        
        input.didClickPlanetsOption
            .sink { [unowned self] _ in
                onIsSpinnerPresentedPublisher.send(true)
                getPlanets()
                    .sink { [weak self] response in
                        if case let .failure(error) = response {
                            self?.errorPublisher.send(error)
                        }
                    } receiveValue: { [weak self] planets in
                        self?.showPlanetsDetails(planets)
                    }
                    .store(in: &cancellables)
            }
            .store(in: &cancellables)
        
        input.didClickFilmsOption
            .sink { [unowned self] _ in
                onIsSpinnerPresentedPublisher.send(true)
                getFilms()
                    .sink { [weak self] response in
                        if case let .failure(error) = response {
                            self?.errorPublisher.send(error)
                        }
                    } receiveValue: { [weak self] films in
                        self?.showFilmDetails(films)
                    }
                    .store(in: &cancellables)
            }
            .store(in: &cancellables)
        
        
        return Output(
            onError:                errorPublisher.eraseToAnyPublisher(),
            onIsSpinnerPresented:   onIsSpinnerPresentedPublisher.eraseToAnyPublisher(),
            onPush:                 onPush.eraseToAnyPublisher()
        )
    }
}

//MARK: Interactor
extension MainViewModel {
    
    private func getPeople() -> AnyPublisher<[Person], ServiceError> {
        //return services.people.getAll()                   // fetch standard, simplified way
        return services.people.getAll_genericContainer()    // fetch using GenericContainer
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
        onIsSpinnerPresentedPublisher.send(false)
        onPush.send(.peopleList(people))
    }
    
    private func showPlanetsDetails(_ planets: [Planet]) {
        onIsSpinnerPresentedPublisher.send(false)
        onPush.send(.planetsList(planets))
    }
    
    private func showFilmDetails(_ films: [Film]) {
        onIsSpinnerPresentedPublisher.send(false)
        onPush.send(.filmsList(films))
    }
}
