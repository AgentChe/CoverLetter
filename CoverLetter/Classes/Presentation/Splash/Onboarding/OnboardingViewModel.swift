//
//  OnboardingViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import RxSwift
import RxCocoa

final class OnboardingViewModel {
    enum Route {
        case paygateTransitionMain, paygateTransitionSuggestCreateCL, main, suggestCreateCL
    }
    
    private lazy var resumeManager = ResumeManager()
}

// MARK: Public
extension OnboardingViewModel {
    struct Input {
        let didCompleteOnboarding: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(didCompleteOnboarding: input.didCompleteOnboarding)
        )
    }
}

// MARK: Private
private extension OnboardingViewModel {
    func makeRoute(didCompleteOnboarding: Signal<Void>) -> Driver<Route> {
        didCompleteOnboarding
            .flatMapLatest { [weak self] void -> Driver<Route> in
                guard let self else { return .never() }
                
                return resumeManager
                    .obtainCVs()
                    .map { cvs -> Route in
                        let hasActiveSubscriptions = SessionManager().hasActiveSubscriptions()
                        
                        if cvs.isEmpty {
                            return hasActiveSubscriptions ? .suggestCreateCL : .paygateTransitionSuggestCreateCL
                        } else {
                            return hasActiveSubscriptions ? .main : .paygateTransitionMain
                        }
                    }
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}
