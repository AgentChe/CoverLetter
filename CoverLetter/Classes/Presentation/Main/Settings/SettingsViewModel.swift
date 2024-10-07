//
//  SettingsViewModel.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

import RxSwift
import RxCocoa

final class SettingsViewModel {
    enum Route {
        case open(URL)
    }
}

// MARK: Public
extension SettingsViewModel {
    struct Input {
        let didTapLink: Signal<URL>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(didTapLink: input.didTapLink)
        )
    }
}

// MARK: Private
private extension SettingsViewModel {
    func makeRoute(didTapLink: Signal<URL>) -> Driver<Route> {
        let open = didTapLink
            .map { Route.open($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(open)
    }
}
