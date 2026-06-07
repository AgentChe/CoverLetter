//
//  PaygateViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class PaygateViewController: UIViewController {
    private lazy var mainView =  PaygateView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = PaygateViewModel()
    
    private let didClose: (() -> Void)?
    
    private init(didClose: (() -> Void)?) {
        self.didClose = didClose
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable
            .merge(
                mainView.leftOptionButton.rx.tap.map { (true, false) },
                mainView.rightOptionButton.rx.tap.map { (false, true) }
            )
            .startWith((true, false))
            .bind(to: Binder(mainView) { base, args in
                base.leftOptionButton.marked = args.0
                base.rightOptionButton.marked = args.1
            })
            .disposed(by: disposeBag)
        
        let didBuy = mainView.continueButton.rx.tap
            .compactMap { [weak self] void -> String? in
                guard let self else {
                    return nil
                }

                let id = [
                    self.mainView.leftOptionButton,
                    self.mainView.rightOptionButton
                ].first(where: { $0.marked })?.info?.productId

                return id
            }
            .asSignal(onErrorSignalWith: .never())
        
        let output = viewModel.configure(input: PaygateViewModel.Input(
            didTapClose: mainView.closeButton.rx.tap.asSignal(),
            didTapBuy: didBuy,
            didTapRestore: mainView.restoreButton.rx.tap.asSignal(),
            didTapTermsOfUse: mainView.termsOfServiceButton.rx.tap.asSignal(),
            didTapPrivacyPolicy: mainView.privacyPolicyButton.rx.tap.asSignal()
        ))
        
        output.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.products
            .drive(Binder(mainView) { base, products in
                base.leftOptionButton.info = products?.first(where: { $0.productId == GlobalDefinitions.Paygate.defaultLifetime })
                base.rightOptionButton.info = products?.first(where: { $0.productId == GlobalDefinitions.Paygate.defaultMonthly })
            })
            .disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: Make
extension PaygateViewController {
    static func make(didClose: (() -> Void)? = nil) -> PaygateViewController {
        let vc = PaygateViewController(didClose: didClose)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension PaygateViewController {
    func activity(_ activity: Bool) {
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
        
        mainView.leftOptionButton.isHidden = activity
        mainView.rightOptionButton.isHidden = activity
        mainView.continueButton.isHidden = activity
        mainView.restoreButton.isHidden = activity
    }
    
    func route(_ route: PaygateViewModel.Route) {
        switch route {
        case .dismiss:
            dismiss(animated: true) { [weak self] in
                self?.didClose?()
            }
        case .error:
            showError()
        case .open(let url):
            UIApplication.shared.open(url)
        }
    }
    
    func showError() {
        let alert = UIAlertController(title: "Paygate.Error.Title".localized, message: "Paygate.Error.Text".localized, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Paygate.Error.Button".localized, style: .cancel)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
