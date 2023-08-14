//
//  PeopleListViewModel.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 14/08/2023.
//

import Combine

class PeopleListViewModel {
    
    let people: [Person]
    
    init(people: [Person]) {
        self.people = people
    }
    
    
    // MARK: Input / Output
    
    struct Input {
        let selectedPerson:    AnyPublisher<Person, Never>
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
    
    private let onHomeworld = PassthroughSubject<Planet, Never>()
    private var onFilms = PassthroughSubject<[Film], Never>()
    
    
    // MARK: Transform
    
    func transform(_ input: Input) -> Output {
        
        errorPublisher
            .sink { [weak self] _ in
                self?.onIsSpinnerPresentedPublisher.send(false)
            }
            .store(in: &cancellables)
        
        input.selectedPerson
            .sink { [weak self] person in
                self?.onIsSpinnerPresentedPublisher.send(true)
                self?.getHomeworld(id: person.homeworldId)
                self?.getFilms(ids: person.filmsIds)
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest(onHomeworld, onFilms)
            .sink { [weak self] (homeworld, films) in
                self?.onIsSpinnerPresentedPublisher.send(false)
                self?.showDetails([
                    homeworld.prettyPrinted,
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
extension PeopleListViewModel {
    
    private func getHomeworld(id: String?) {
        guard let id = id else {
            errorPublisher.send(.wrongId)
            return
        }
        
        services.planet.getPlanet(id: id)
            .sink { [unowned self] result in
                if case let .failure(error) = result {
                    errorPublisher.send(error)
                }
            } receiveValue: { [unowned self] planet in
                onHomeworld.send(planet)
            }
            .store(in: &cancellables)
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
extension PeopleListViewModel {
    
    private func showDetails(_ prettyStrings: [String]) {
        onShow.send(.details(prettyStrings.joined(separator: "\n")))
    }
}
