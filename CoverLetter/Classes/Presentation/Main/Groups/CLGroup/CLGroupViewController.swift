//
//  CLGroupViewController.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 08.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class CLGroupViewController: UIViewController {
    private lazy var mainView = CLGroupView(title: initialGroup.name)
    
    private lazy var viewModel = CLGroupViewModel(group: initialGroup)
    
    private lazy var disposeBag = DisposeBag()
    
    private let initialGroup: CLsGroup
    
    private lazy var didTapDuplicateTrigger = PublishRelay<CL>()
    private lazy var didTapShareTrigger = PublishRelay<CL>()
    private lazy var didTapDeleteTrigger = PublishRelay<CL>()
    
    private init(group: CLsGroup) {
        self.initialGroup = group
        
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
        
        let output = viewModel.configure(input: CLGroupViewModel.Input(
            didTapBack: mainView.backButton.rx.tap.asSignal(),
            didTapCreateNew: mainView.createNewButton.rx.tap.asSignal(),
            didSelectCL: mainView.collectionView.didSelectCL,
            didMenuTap: mainView.collectionView.didMenuTap,
            didTapDuplicate: didTapDuplicateTrigger.asSignal(),
            didTapShare: didTapShareTrigger.asSignal(),
            didTapDelete: didTapDeleteTrigger.asSignal()
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
extension CLGroupViewController {
    static func make(group: CLsGroup) -> CLGroupViewController {
        CLGroupViewController(group: group)
    }
}

// MARK: Private
private extension CLGroupViewController {
    func route(_ route: CLGroupViewModel.Route) {
        switch route {
        case .back:
            navigationController?.popViewController(animated: true)
        case .createNew:
            let vc = CLMakerViewController.make(mode: .create)
            present(vc, animated: true)
        case .edit(let cl):
            let vc = CLMakerViewController.make(mode: .edit(cl))
            present(vc, animated: true)
        case .menu(let cl):
            let vc = ClGroupMenuViewController.make { [weak self] action in
                switch action {
                case .duplicate:
                    self?.didTapDuplicateTrigger.accept(cl)
                case .share:
                    self?.didTapShareTrigger.accept(cl)
                case .delete:
                    self?.didTapDeleteTrigger.accept(cl)
                }
            }
            present(vc, animated: false)
        case .share(let cl):
            let pdf = PDFFactory.createCL(cl: cl)
            let vc = UIActivityViewController(activityItems: [pdf], applicationActivities: nil)
            present(vc, animated: true)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
}
