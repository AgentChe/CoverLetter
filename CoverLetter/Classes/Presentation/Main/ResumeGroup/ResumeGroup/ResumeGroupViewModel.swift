//
//  ResumeGroupViewModel.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 29.08.2024.
//

import RxSwift
import RxCocoa

final class ResumeGroupViewModel {
    enum Route {
        case share(RSCollectionElement.Entity)
        case edit(RSCollectionElement.Entity)
        case requestWhatWantCreate
        case paygate
    }
    
    private lazy var resumeManager = ResumeManager()
}

// MARK: Public
extension ResumeGroupViewModel {
    struct Input {
        let group: Driver<ResumeGroup>
        let didScrollTo: Signal<RSCollectionElement>
        let didTapAddNew: Signal<Void>
        let didTapShare: Signal<Void>
        let didTapEdit: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[RSCollectionElement]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        let group = makeGroup(initial: input.group)
        let elements = makeElements(group: group)
        let currentElement = makeCurrentElement(
            didScrollTo: input.didScrollTo,
            elements: elements
        )
        
        return Output(
            elements: elements,
            route: makeRoute(
                currentElement: currentElement,
                didTapAddNew: input.didTapAddNew,
                didTapShare: input.didTapShare,
                didTapEdit: input.didTapEdit
            )
        )
    }
}

// MARK: Private
private extension ResumeGroupViewModel {
    func makeElements(group: Driver<ResumeGroup>) -> Driver<[RSCollectionElement]> {
        group
            .map { group -> [RSCollectionElement] in
                let cvs = group.cvs.map { RSCollectionElement(entity: .cv($0)) }
                let cls = group.cls.map { RSCollectionElement(entity: .cl($0)) }
                return cvs + cls
            }
    }
    
    func makeGroup(initial: Driver<ResumeGroup>) -> Driver<ResumeGroup> {
        let updated = ResumeMediator.shared
            .didChangedGroups
            .withLatestFrom(initial)
            .flatMapLatest { [weak self] initial -> Driver<ResumeGroup> in
                guard let self else { return .never() }
                
                return self.resumeManager
                    .obtainGroups()
                    .compactMap { $0.first(where: { $0.id == initial.id }) }
                    .asDriver(onErrorDriveWith: .never())
            }
        
        return Driver
            .merge(initial, updated)
    }
    
    func makeRoute(
        currentElement: Driver<RSCollectionElement>,
        didTapAddNew: Signal<Void>,
        didTapShare: Signal<Void>,
        didTapEdit: Signal<Void>
    ) -> Driver<Route> {
        let shareOrPaygate = didTapShare
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(currentElement)
            .map { element -> Route in
                SessionManager().hasActiveSubscriptions() ? Route.share(element.entity) : Route.paygate
            }
        
        let editOrPaygate = didTapEdit
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(currentElement)
            .map { element -> Route in
                SessionManager().hasActiveSubscriptions() ? Route.edit(element.entity) : Route.paygate
            }
        
        let requestWhatWantCreate = didTapAddNew
            .map { Route.requestWhatWantCreate }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(
                shareOrPaygate, editOrPaygate, requestWhatWantCreate
            )
    }
    
    func makeCurrentElement(
        didScrollTo: Signal<RSCollectionElement>,
        elements: Driver<[RSCollectionElement]>
    ) -> Driver<RSCollectionElement> {
        let initial = elements
            .asObservable()
            .take(1)
            .compactMap { $0.first }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(
                initial,
                didScrollTo.asDriver(onErrorDriveWith: .never())
            )
    }
}
