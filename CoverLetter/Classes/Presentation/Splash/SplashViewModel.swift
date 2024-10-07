//
//  SplashViewModel.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.08.2024.
//

import RxSwift
import RxCocoa

final class SplashViewModel {
    enum Route {
        case onboarding, paygateTransitionMain, paygateTransitionCVMaker, main, cvMaker
    }
    
    private lazy var resumeManager = ResumeManager()
}

extension SplashViewModel {
    struct Input {
        let didSDKConfigured: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(didSDKConfigured: input.didSDKConfigured)
        )
    }
}

// MARK: Private
private extension SplashViewModel {
    func makeRoute(didSDKConfigured: Signal<Void>) -> Driver<Route> {
        didSDKConfigured
            .flatMapLatest { [weak self] void -> Driver<Route> in
                guard let self else { return .never() }
                
                if !OnboardingViewController.wasViewed() {
                    return .just(.onboarding)
                }
                
                return resumeManager
                    .obtainCVs()
                    .map { cvs -> Route in
                        let hasActiveSubscriptions = SessionManager().hasActiveSubscriptions()
                        
                        if cvs.isEmpty {
                            return hasActiveSubscriptions ? .cvMaker : .paygateTransitionCVMaker
                        } else {
                            return hasActiveSubscriptions ? .main : .paygateTransitionMain
                        }
                    }
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}
