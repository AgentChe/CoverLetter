//
//  SettingsViewController.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsViewController: UIViewController {
    private lazy var mainView = SettingsView()
    
    private lazy var viewModel = SettingsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: SettingsViewModel.Input(
            didTapLink: Signal<URL>.merge(
                mainView.termsOfUseButton.didTapLink,
                mainView.privacyPolicyButton.didTapLink,
                mainView.contactUsButton.didTapLink
            )
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SettingsViewController {
    static func make() -> SettingsViewController {
        let vc = SettingsViewController()
        vc.navigationItem.title = "Settings.Title".localized
        return vc
    }
}

// MARK: Private
private extension SettingsViewController {
    func route(_ route: SettingsViewModel.Route) {
        switch route {
        case .open(let url):
            UIApplication.shared.open(url)
        }
    }
}
