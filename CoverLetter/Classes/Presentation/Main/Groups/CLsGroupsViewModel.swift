//
//  CLsGroupsViewModel.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 08.10.2024.
//

import RxSwift
import RxCocoa

final class CLsGroupsViewModel {
    enum Route {
        case clsGroup(CLsGroup)
        case createNew
    }
    
    private lazy var resumeManager = ResumeManager()
}

// MARK: Public
extension CLsGroupsViewModel {
    struct Input {
        let didSelectGroup: Signal<CLsGroup>
        let didTapCreateNew: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[CLsGroup]>
        let isEmpty: Driver<Bool>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let elements = makeElements()
        
        return Output(
            elements: elements,
            isEmpty: makeIsEmpty(elements: elements),
            route: makeRoute(
                didSelectGroup: input.didSelectGroup,
                didTapCreateNew: input.didTapCreateNew
            )
        )
    }
}

// MARK: Private
private extension CLsGroupsViewModel {
    func makeElements() -> Driver<[CLsGroup]> {
        ResumeMediator.shared.didChangedGroups
            .startWith(())
            .flatMapLatest { [weak self] void -> Signal<[CLsGroup]> in
                guard let self else { return .never() }
                
                return resumeManager
                    .obtainGroups()
                    .asSignal(onErrorJustReturn: [])
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeIsEmpty(elements: Driver<[CLsGroup]>) -> Driver<Bool> {
        elements
            .map { $0.isEmpty }
            .startWith(false)
    }
    
    func makeRoute(
        didSelectGroup: Signal<CLsGroup>,
        didTapCreateNew: Signal<Void>
    ) -> Driver<Route> {
        let group = didSelectGroup
            .map { Route.clsGroup($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let createNew = didTapCreateNew
            .map { Route.createNew }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(group, createNew)
    }
}
