//
//  MainViewController.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    private lazy var mainView = MainView()
    
    private lazy var viewModel = MainViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var profileButton = TapAreaButton()
    
    private lazy var didDeleteGroupTrigger = PublishRelay<ResumeGroup>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationButtons()
        
        let output = viewModel.configure(input: MainViewModel.Input(
            didTapProfile: profileButton.rx.tap.asSignal(),
            didTapMenu: mainView.collectionView.didTapMenu,
            didSelectGroup: mainView.collectionView.didSelect,
            didDeleteGroup: didDeleteGroupTrigger.asSignal()
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.collectionView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.disposable
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension MainViewController {
    static func make() -> MainViewController {
        let vc = MainViewController()
        vc.navigationItem.title = "Main.Title".localized
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension MainViewController {
    func route(_ route: MainViewModel.Route) {
        switch route {
        case .profile:
            let vc = ProfileViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .menu(let group):
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Main.Menu.Delete".localized, style: .destructive) { [weak self] action in
                self?.didDeleteGroupTrigger.accept(group)
            }
            alert.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        case .select(let group):
            let vc = ResumeGroupViewController.make(group: group)
            present(vc, animated: true)
        }
    }
    
    func addNavigationButtons() {
        profileButton.setImage(UIImage(named: "Main.Profile"), for: .normal)
        
        let item = UIBarButtonItem(customView: profileButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 15.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 16.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
    }
}
