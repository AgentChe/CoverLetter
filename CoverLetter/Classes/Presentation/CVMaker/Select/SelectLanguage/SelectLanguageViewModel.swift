//
//  SelectLanguageViewModel.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

import RxSwift
import RxCocoa

final class SelectLanguageViewModel {
    enum Route {
        case selected(String)
    }
    
    private lazy var contentManager = ContentManager()
}

// MARK: Public
extension SelectLanguageViewModel {
    struct Input {
        let filter: Signal<String>
        let didSelect: Signal<String>
    }
    
    struct Output {
        let elements: Driver<[String]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            elements: makeElements(filter: input.filter),
            route: makeRoute(didSelect: input.didSelect)
        )
    }
}

// MARK: Private
private extension SelectLanguageViewModel {
    func makeElements(filter: Signal<String>) -> Driver<[String]> {
        Driver
            .combineLatest(
                contentManager.obtainLanguages().asDriver(onErrorJustReturn: []),
                filter.asDriver(onErrorDriveWith: .never()).startWith("")
            ) { isoLanguages, filter -> [String] in
                if filter.isEmpty {
                    return isoLanguages
                }
                
                return isoLanguages.filter { $0.contains(filter) }
            }
    }
    
    func makeRoute(didSelect: Signal<String>) -> Driver<Route> {
        didSelect
            .map { Route.selected($0) }
            .asDriver(onErrorDriveWith: .never())
    }
}
