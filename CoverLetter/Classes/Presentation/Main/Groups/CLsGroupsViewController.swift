//
//  CLsGroupsViewController.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 08.10.2024.
//

import UIKit
import RxSwift

final class CLsGroupsViewController: UIViewController {
    private lazy var mainView = CLsGroupsView()
    
    private lazy var viewModel = CLsGroupsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: CLsGroupsViewModel.Input(
            didSelectGroup: mainView.tableView.didSelectGroup,
            didTapCreateNew: mainView.createNewButton.rx.tap.asSignal(onErrorSignalWith: .never())
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.isEmpty
            .drive(Binder(mainView) { base, isEmpty in
                base.emptyView.isHidden = !isEmpty
                base.tableView.isHidden = isEmpty
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: Public
extension CLsGroupsViewController {
    static func make() -> CLsGroupsViewController {
        CLsGroupsViewController()
    }
}

// MARK: Private
private extension CLsGroupsViewController {
    func route(_ route: CLsGroupsViewModel.Route) {
        switch route {
        case .clsGroup(let group):
            break // TODO
        case .createNew:
            let vc = CLMakerViewController.make(mode: .create)
            present(vc, animated: true)
        }
    }
}
