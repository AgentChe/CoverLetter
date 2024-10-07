//
//  ResumeGroupViewController.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 29.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class ResumeGroupViewController: UIViewController {
    private lazy var mainView = ResumeGroupView()
    
    private lazy var viewModel = ResumeGroupViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let group: ResumeGroup
    
    private init(group: ResumeGroup) {
        self.group = group
        
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
        
        addCloseButton()
        
        let output = viewModel.configure(input: ResumeGroupViewModel.Input(
            group: BehaviorRelay(value: group).asDriver(onErrorDriveWith: .never()),
            didScrollTo: mainView.collectionView.didScrollTo,
            didTapAddNew: mainView.addNewButton.rx.tap.asSignal(),
            didTapShare: mainView.shareButton.rx.tap.asSignal(),
            didTapEdit: mainView.editButton.rx.tap.asSignal()
        ))
        
        output.elements
            .drive(Binder(mainView.collectionView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension ResumeGroupViewController {
    static func make(group: ResumeGroup) -> NavigationController {
        let vc = ResumeGroupViewController(group: group)
        vc.navigationItem.title = group.name
        let nc = NavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        return nc
    }
}

// MARK: Private
private extension ResumeGroupViewController {
    func addCloseButton() {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "Paygate.Close"), for: .normal)
        
        let item = UIBarButtonItem(customView: button)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 24.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 24.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
        
        button.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func route(_ route: ResumeGroupViewModel.Route) {
        switch route {
        case .share(let entity):
            switch entity {
            case .cv(let cv):
                let pdf = PDFFactory.createCV(cv: cv)
                let vc = UIActivityViewController(activityItems: [pdf], applicationActivities: nil)
                present(vc, animated: true)
            case .cl(let cl):
                let pdf = PDFFactory.createCL(cl: cl)
                let vc = UIActivityViewController(activityItems: [pdf], applicationActivities: nil)
                present(vc, animated: true)
            }
        case .edit(let entity):
            switch entity {
            case .cv(let cv):
                let vc = CVMakerViewController.make(mode: .edit(cv), stepAfterCancelFlow: .dismiss)
                present(vc, animated: true)
            case .cl(let cl):
                let vc = CLMakerViewController.make(mode: .edit(cl))
                present(vc, animated: true)
            }
        case .requestWhatWantCreate:
            let vc = RWWCViewController.make { [weak self] entity in
                switch entity {
                case .cv:
                    let vc = CVMakerViewController.make(mode: .create, stepAfterCancelFlow: .dismiss)
                    self?.present(vc, animated: true)
                case .cl:
                    let vc = CLMakerViewController.make(mode: .create)
                    self?.present(vc, animated: true)
                }
            }
            present(vc, animated: false)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
}
