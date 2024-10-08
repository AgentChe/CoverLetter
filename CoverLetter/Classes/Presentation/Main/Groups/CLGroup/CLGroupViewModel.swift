//
//  CLGroupViewModel.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 08.10.2024.
//

import RxSwift
import RxCocoa

final class CLGroupViewModel {
    enum Route {
        case back
        case createNew
        case edit(CL)
        case menu(CL)
    }
    
    enum Action {
        case share(CL)
    }
    
    private let initialGroup: Driver<CLsGroup>
    
    private lazy var resumeManager = ResumeManager()
    
    init(group: CLsGroup) {
        self.initialGroup = BehaviorRelay(value: group).asDriver(onErrorDriveWith: .never())
    }
}

// MARK: Public
extension CLGroupViewModel {
    struct Input {
        let didTapBack: Signal<Void>
        let didTapCreateNew: Signal<Void>
        let didSelectCL: Signal<CL>
        let didMenuTap: Signal<CL>
        let didTapDuplicate: Signal<CL>
        let didTapShare: Signal<CL>
        let didTapDelete: Signal<CL>
    }
    
    struct Output {
        let route: Driver<Route>
        let elements: Driver<[CL]>
        let action: Driver<Action>
        let disposable: Disposable
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapBack: input.didTapBack,
                didTapCreateNew: input.didTapCreateNew,
                didSelectCL: input.didSelectCL,
                didMenuTap: input.didMenuTap
            ),
            elements: makeElements(initialGroup: initialGroup),
            action: makeAction(didTapShare: input.didTapShare),
            disposable: makeDisposable(
                didTapDuplicate: input.didTapDuplicate,
                didTapDelete: input.didTapDelete
            )
        )
    }
}

// MARK: Private
private extension CLGroupViewModel {
    func makeRoute(
        didTapBack: Signal<Void>,
        didTapCreateNew: Signal<Void>,
        didSelectCL: Signal<CL>,
        didMenuTap: Signal<CL>
    ) -> Driver<Route> {
        let back = didTapBack
            .map { Route.back }
            .asDriver(onErrorDriveWith: .never())
        
        let createNew = didTapCreateNew
            .map { Route.createNew }
            .asDriver(onErrorDriveWith: .never())
        
        let edit = didSelectCL
            .map { Route.edit($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let menu = didMenuTap
            .map { Route.menu($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(back, createNew, edit, menu)
    }
    
    func makeElements(initialGroup: Driver<CLsGroup>) -> Driver<[CL]> {
        let initial = initialGroup.map { $0.cls }
        
        let updated = ResumeMediator.shared
            .didChangedGroups
            .withLatestFrom(initialGroup)
            .flatMapLatest { [weak self] initial -> Driver<CLsGroup?> in
                guard let self else { return .never() }

                return self.resumeManager
                    .obtainGroups()
                    .map { $0.first(where: { $0.id == initial.id }) }
                    .asDriver(onErrorDriveWith: .never())
            }
            .map { $0?.cls ?? [] }
        
        return Driver
            .merge(initial, updated)
    }
    
    func makeAction(didTapShare: Signal<CL>) -> Driver<Action> {
        let share = didTapShare
            .map { Action.share($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(share)
    }
    
    func makeDisposable(
        didTapDuplicate: Signal<CL>,
        didTapDelete: Signal<CL>
    ) -> Disposable {
        let duplicate = didTapDuplicate
            .flatMapLatest { [weak self] cl -> Signal<CL> in
                guard let self else { return .never() }
                
                return resumeManager
                    .createCL(
                        template: cl.template,
                        info: cl.info
                    )
                    .asSignal(onErrorSignalWith: .never())
            }
            .emit()
        
        let delete = didTapDelete
            .flatMapLatest { [weak self] cl -> Signal<Void> in
                guard let self else { return .never() }
                
                return resumeManager
                    .removeCL(id: cl.id)
                    .asSignal(onErrorSignalWith: .never())
            }
            .emit()
        
        return Disposables
            .create([duplicate, delete])
    }
}
