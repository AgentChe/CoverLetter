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
        case onboarding, paygateTransitionMain, main
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
            .map { void -> Route in
                if !OnboardingViewController.wasViewed() {
                    return .onboarding
                }
                
                let hasActiveSubscriptions = SessionManager().hasActiveSubscriptions()
                
                return hasActiveSubscriptions ? .main : .paygateTransitionMain
            }
            .asDriver(onErrorDriveWith: .never())
    }
}
