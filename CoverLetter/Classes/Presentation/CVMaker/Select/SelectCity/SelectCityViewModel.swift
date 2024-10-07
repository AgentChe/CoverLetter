//
//  SelectCityViewModel.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

import RxSwift
import RxCocoa

final class SelectCityViewModel {
    enum Flow {
        case selectCountry, selectCity(Country)
    }
    
    struct FlowResult {
        let country: Country
        let city: City
    }
    
    enum Route {
        case selectedCountry(Country)
        case completeFlow(FlowResult)
    }
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var contentManager = ContentManager()
}

// MARK: Public
extension SelectCityViewModel {
    struct Input {
        let flow: Flow
        let filter: Signal<String>
        let didSelect: Signal<SelectCityTableElement>
    }
    
    struct Output {
        let activity: Driver<Bool>
        let elements: Driver<[SelectCityTableElement]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let elements = makeElements(flow: input.flow)
        
        return Output(
            activity: activity.asDriver(),
            elements: makeFiltered(
                elements: elements, 
                filter: input.filter
            ),
            route: makeRoute(
                flow: input.flow,
                didSelect: input.didSelect
            )
        )
    }
}

// MARK: Private
private extension SelectCityViewModel {
    func makeRoute(flow: Flow, didSelect: Signal<SelectCityTableElement>) -> Driver<Route> {
        didSelect
            .asDriver(onErrorDriveWith: .never())
            .compactMap { element -> Route? in
                switch element {
                case .country(let country):
                    return .selectedCountry(country)
                case .city(let city):
                    guard case let .selectCity(country) = flow else {
                        return nil
                    }
                    
                    let flowResult = FlowResult(country: country, city: city)
                    return .completeFlow(flowResult)
                }
            }
    }
    
    func makeFiltered(
        elements: Driver<[SelectCityTableElement]>,
        filter: Signal<String>
    ) -> Driver<[SelectCityTableElement]> {
        Driver
            .combineLatest(
                elements,
                filter
                    .asDriver(onErrorDriveWith: .never())
                    .startWith("")
            )
            .map { elements, filter -> [SelectCityTableElement] in
                guard !filter.isEmpty else {
                    return elements
                }
                
                return elements.filter { $0.name.range(of: filter, options: .caseInsensitive) != nil }
            }
    }
    
    func makeElements(flow: Flow) -> Driver<[SelectCityTableElement]> {
        BehaviorRelay(value: flow)
            .flatMapLatest { [weak self] flow -> Driver<[SelectCityTableElement]> in
                guard let self else {
                    return .never()
                }
                
                switch flow {
                case .selectCountry:
                    return self.contentManager
                        .obtainCountries()
                        .trackActivity(self.activity)
                        .map { countries -> [SelectCityTableElement] in
                            countries.map { SelectCityTableElement.country($0) }
                        }
                        .asDriver(onErrorJustReturn: [])
                case .selectCity(let country):
                    return self.contentManager
                        .obtainCities(iso2: country.iso2)
                        .trackActivity(self.activity)
                        .map { cities -> [SelectCityTableElement] in
                            cities.map { SelectCityTableElement.city($0) }
                        }
                        .asDriver(onErrorJustReturn: [])
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
}
