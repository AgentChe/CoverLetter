//
//  OnboardingViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingViewController: UIViewController {
    struct Constants {
        static let wasViewedKey = "onboarding_view_controller_was_viewed_key"
    }
    
    private lazy var mainView = OnboardingView()
    
    private lazy var viewModel = OnboardingViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didCompleteOnboardingTrigger = PublishRelay<Void>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: OnboardingViewModel.Input(
            didCompleteOnboarding: didCompleteOnboardingTrigger.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        mainView.didFinish = { [weak self] in
            self?.markAsViewed()
            self?.didCompleteOnboardingTrigger.accept(Void())
        }
    }
}

// MARK: Public
extension OnboardingViewController {
    static func make() -> OnboardingViewController {
        OnboardingViewController()
    }
    
    static func wasViewed() -> Bool {
        UserDefaults.standard.bool(forKey: OnboardingViewController.Constants.wasViewedKey)
    }
}

// MARK: Private
private extension OnboardingViewController {
    func markAsViewed() {
        UserDefaults.standard.setValue(true, forKey: Constants.wasViewedKey)
    }
    
    func route(_ route: OnboardingViewModel.Route) {
        switch route {
        case .paygateTransitionMain:
            let vc = PaygateViewController.make { [weak self] in
                self?.route(.main)
            }
            present(vc, animated: true)
        case .paygateTransitionSuggestCreateCL:
            let vc = PaygateViewController.make { [weak self] in
                self?.route(.suggestCreateCL)
            }
            present(vc, animated: true)
        case .main:
            UIApplication.shared.keyWindow?.rootViewController = MainViewController.make()
        case .suggestCreateCL:
            UIApplication.shared.keyWindow?.rootViewController = SuggestCreateCLViewController.make()
        }
    }
}
