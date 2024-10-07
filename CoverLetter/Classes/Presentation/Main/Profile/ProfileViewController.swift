//
//  ProfileViewController.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: UIViewController {
    private lazy var mainView = ProfileView()
    
    private lazy var viewModel = ProfileViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var settingsButton = TapAreaButton()
    
    private lazy var didConfirmedDeleteProfileTrigger = PublishRelay<Void>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationButtons()
        
        let output = viewModel.configure(input: ProfileViewModel.Input(
            didTapSettings: settingsButton.rx.tap.asSignal(),
            didTapDeleteProfile: mainView.tableView.didDelete,
            didConfirmedDeleteProfile: didConfirmedDeleteProfileTrigger.asSignal(),
            didSelectCVMakerChapter: mainView.tableView.didSelect
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            }).disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.actions
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.disposable
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension ProfileViewController {
    static func make() -> ProfileViewController {
        let vc = ProfileViewController()
        vc.navigationItem.title = "Profile.Title".localized
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension ProfileViewController {
    func addNavigationButtons() {
        settingsButton.setImage(UIImage(named: "Profile.Settings"), for: .normal)
        
        let item = UIBarButtonItem(customView: settingsButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 15.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 16.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
    }
    
    func route(_ route: ProfileViewModel.Route) {
        switch route {
        case .settings:
            let vc = SettingsViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .changeCVMakerChapter(let chapter):
            let vc: CVMakerChapterViewController
            
            switch chapter {
            case .generalInfo:
                vc = CVMakerChapterViewController.make(chapter: .generalInfo)
            case .workExperience:
                vc = CVMakerChapterViewController.make(chapter: .workExperience)
            case .education:
                vc = CVMakerChapterViewController.make(chapter: .education)
            case .professionalSkills:
                vc = CVMakerChapterViewController.make(chapter: .professionalSkills)
            case .languages:
                vc = CVMakerChapterViewController.make(chapter: .languages)
            case .interests:
                vc = CVMakerChapterViewController.make(chapter: .interests)
            case .certificates:
                vc = CVMakerChapterViewController.make(chapter: .certificates)
            case .socialMedia:
                vc = CVMakerChapterViewController.make(chapter: .socialMedia)
            case .references:
                vc = CVMakerChapterViewController.make(chapter: .references)
            }
            
            present(vc, animated: true)
        }
    }
    
    func action(_ action: ProfileViewModel.Action) {
        switch action {
        case .confirmDeleteProfile:
            let alert = UIAlertController(
                title: "Profile.ConfirmDelete.Title".localized, 
                message: "Profile.ConfirmDelete.SubTitle".localized,
                preferredStyle: .alert
            )
            
            let deleteAction = UIAlertAction(title: "Profile.ConfirmDelete.DeleteAction".localized, style: .default) { [weak self] action in
                self?.didConfirmedDeleteProfileTrigger.accept(Void())
            }
            alert.addAction(deleteAction)
            
            let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel)
            alert.addAction(cancel)
            
            present(alert, animated: true)
        }
    }
}
