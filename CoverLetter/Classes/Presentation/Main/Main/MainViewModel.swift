//
//  MainViewModel.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.08.2024.
//

import RxSwift
import RxCocoa

final class MainViewModel {
    enum Route {
        case profile
        case select(ResumeGroup)
        case menu(ResumeGroup)
    }
    
    private lazy var resumeManager = ResumeManager()
}

// MARK: Public
extension MainViewModel {
    struct Input {
        let didTapProfile: Signal<Void>
        let didTapMenu: Signal<ResumeGroup>
        let didSelectGroup: Signal<ResumeGroup>
        let didDeleteGroup: Signal<ResumeGroup>
    }
    
    struct Output {
        let route: Driver<Route>
        let elements: Driver<[ResumeGroup]>
        let disposable: Disposable
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapProfile: input.didTapProfile,
                didTapMenu: input.didTapMenu,
                didSelectGroup: input.didSelectGroup
            ),
            elements: makeElements(),
            disposable: makeDisposable(didDeleteGroup: input.didDeleteGroup)
        )
    }
}

// MARK: Private
private extension MainViewModel {
    func makeRoute(
        didTapProfile: Signal<Void>,
        didTapMenu: Signal<ResumeGroup>,
        didSelectGroup: Signal<ResumeGroup>
    ) -> Driver<Route> {
        let profile = didTapProfile
            .map { Route.profile }
            .asDriver(onErrorDriveWith: .never())
        
        let menu = didTapMenu
            .map { Route.menu($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let selectGroup = didSelectGroup
            .map { Route.select($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(profile, menu, selectGroup)
    }
    
    func makeElements() -> Driver<[ResumeGroup]> {
        let triggers = ResumeMediator.shared.didChangedGroups
            .startWith(())
        
        return triggers
            .flatMapLatest { [weak self] void -> Signal<[ResumeGroup]> in
                guard let self else { return .never() }
                
                return resumeManager
                    .obtainGroups()
                    .asSignal(onErrorJustReturn: [])
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeDisposable(didDeleteGroup: Signal<ResumeGroup>) -> Disposable {
        let deleteGroup = didDeleteGroup
            .flatMapLatest { [weak self] group -> Signal<Void> in
                guard let self else { return .never() }
                
                return resumeManager
                    .removeGroup(id: group.id)
                    .asSignal(onErrorSignalWith: .never())
            }
            .emit()
        
        return Disposables.create([deleteGroup])
    }
}
