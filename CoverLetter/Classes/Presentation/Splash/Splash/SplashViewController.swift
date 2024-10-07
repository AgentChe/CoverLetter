//
//  SplashViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class SplashViewController: UIViewController {
    private lazy var mainView = SplashView()
    
    private lazy var viewModel = SplashViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var sdkInitialize = SplashReceiptValidationObserver()
    
    private lazy var didSDKConfiguredTrigger = PublishRelay<Void>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: SplashViewModel.Input(
            didSDKConfigured: didSDKConfiguredTrigger.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        sdkInitialize.observe { [weak self] in
            self?.didSDKConfiguredTrigger.accept(Void())
        }
    }
}

// MARK: Make
extension SplashViewController {
    static func make() -> SplashViewController {
        SplashViewController()
    }
}

// MARK: Private
private extension SplashViewController {
    func route(_ route: SplashViewModel.Route) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            self?.goNext(route: route)
        }
    }
    
    func goNext(route: SplashViewModel.Route) {
        switch route {
        case .onboarding:
            UIApplication.shared.keyWindow?.rootViewController = OnboardingViewController.make()
        case .paygateTransitionMain:
            let vc = PaygateViewController.make { [weak self] in
                self?.goNext(route: .main)
            }
            present(vc, animated: true)
        case .main:
            UIApplication.shared.keyWindow?.rootViewController = NavigationController(rootViewController: MainViewController.make())
        }
    }
}
