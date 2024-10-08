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
        case paygate
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
        let disposable: Disposable
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapBack: input.didTapBack,
                didTapCreateNew: input.didTapCreateNew,
                didSelectCL: input.didSelectCL,
                didMenuTap: input.didMenuTap,
                didTapShare: input.didTapShare
            ),
            elements: makeElements(initialGroup: initialGroup),
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
        didMenuTap: Signal<CL>,
        didTapShare: Signal<CL>
    ) -> Driver<Route> {
        let back = didTapBack
            .map { Route.back }
            .asDriver(onErrorDriveWith: .never())
        
        let createNew = didTapCreateNew
            .map { Route.createNew }
            .asDriver(onErrorDriveWith: .never())
        
        let editOrPaygate = didSelectCL
            .map { cl -> Route in
                SessionManager().hasActiveSubscriptions() ? .edit(cl) : .paygate
            }
            .asDriver(onErrorDriveWith: .never())
        
        let menu = didMenuTap
            .map { Route.menu($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let shareOrPaygate = didTapShare
            .map { cl -> Route in
                SessionManager().hasActiveSubscriptions() ? .share(cl) : .paygate
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(back, createNew, editOrPaygate, menu, shareOrPaygate)
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
