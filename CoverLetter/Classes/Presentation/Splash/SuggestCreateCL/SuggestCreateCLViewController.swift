//
//  SuggestCreateCLViewController.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 07.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class SuggestCreateCLViewController: UIViewController {
    private lazy var mainView = SuggestCreateCLView()
    
    private lazy var viewModel = SuggestCreateCLViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let requestReview: Bool
    
    private init(requestReview: Bool) {
        self.requestReview = requestReview

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
        
        let output = viewModel.configure(input: SuggestCreateCLViewModel.Input(
            didTapClose: mainView.closeButton.rx.tap.asSignal(onErrorSignalWith: .never()),
            didTapCreate: mainView.createButton.rx.tap.asSignal(onErrorSignalWith: .never())
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        if requestReview {
            RequestReview.request()
        }
    }
}

// MARK: Public
extension SuggestCreateCLViewController {
    static func make(requestReview: Bool) -> SuggestCreateCLViewController {
        let vc = SuggestCreateCLViewController(requestReview: requestReview)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension SuggestCreateCLViewController {
    func route(_ route: SuggestCreateCLViewModel.Route) {
        switch route {
        case .main:
            UIApplication.shared.keyWindow?.rootViewController = MainViewController.make(requestReview: false)
        case .createCL:
            let vc = CLMakerViewController.make(mode: .create) { [weak self] in
                self?.route(.main)
            }
            present(vc, animated: true)
        }
    }
}
