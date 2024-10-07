//
//  SuggestCreateCLViewModel.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 07.10.2024.
//

import RxSwift
import RxCocoa

final class SuggestCreateCLViewModel {
    enum Route {
        case main, createCL
    }
}

// MARK: Public
extension SuggestCreateCLViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapCreate: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapCreate: input.didTapCreate
            )
        )
    }
}

// MARK: Private
private extension SuggestCreateCLViewModel {
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapCreate: Signal<Void>
    ) -> Driver<Route> {
        let main = didTapClose
            .map { Route.main }
            .asDriver(onErrorDriveWith: .never())
        
        let createCL = didTapCreate
            .map { Route.createCL }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(main, createCL)
    }
}
