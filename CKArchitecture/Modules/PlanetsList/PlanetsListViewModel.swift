//
//  PlanetsListViewModel.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 14/08/2023.
//

import Combine

class PlanetsListViewModel {
    
    let planets: [Planet]
    
    init(planets: [Planet]) {
        self.planets = planets
    }
    
    // MARK: Input / Output
    
    struct Input {
        let selectedPlanet:    AnyPublisher<Planet, Never>
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
    
    private let onResidents = PassthroughSubject<[Person], Never>()
    private var onFilms = PassthroughSubject<[Film], Never>()
    
    
    // MARK: Transform
    
    func transform(_ input: Input) -> Output {
        
        errorPublisher
            .sink { [weak self] _ in
                self?.onIsSpinnerPresentedPublisher.send(false)
            }
            .store(in: &cancellables)
        
        input.selectedPlanet
            .sink { [weak self] planet in
                self?.onIsSpinnerPresentedPublisher.send(true)
                self?.getResidents(ids: planet.residentsIds)
                self?.getFilms(ids: planet.filmsIds)
            }
            .store(in: &cancellables)
        
        // `CombineLatest` - emits a value whenever any of its upstream publishers emit a value
        Publishers.CombineLatest(onResidents, onFilms)
            .sink { [weak self] (residents, films) in
                self?.onIsSpinnerPresentedPublisher.send(false)
                self?.showDetails([
                    residents.prettyPrinted,
                    films.prettyPrinted
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
extension PlanetsListViewModel {
    
    private func getResidents(ids: [String]) {
        guard ids.count > 0 else {
            onResidents.send([])
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
                        onResidents.send(residents)
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    private func getFilms(ids: [String]) {
        guard ids.count > 0 else {
            onFilms.send([])
            return
        }
        
        var films: [Film] = []

        ids.forEach { id in
            services.film.getFilm(id: id)
                .sink { [unowned self] result in
                    if case let .failure(error) = result {
                        errorPublisher.send(error)
                    }
                } receiveValue: { [unowned self] film in
                    films.append(film)
                    if films.count == ids.count {
                        onFilms.send(films)
                    }
                }
                .store(in: &cancellables)
        }
    }
}

//MARK: Router
extension PlanetsListViewModel {
    
    private func showDetails(_ prettyStrings: [String]) {
        onShow.send(.details(prettyStrings.joined(separator: "\n")))
    }
}
