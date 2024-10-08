//
//  ClGroupMenuViewController.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 08.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class ClGroupMenuViewController: UIViewController {
    private lazy var mainView = ClGroupMenuView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let action: (ClGroupMenuButton.Action) -> Void
    
    private init(action: @escaping (ClGroupMenuButton.Action) -> Void) {
        self.action = action
        
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
        
        Signal<ClGroupMenuButton.Action>
            .merge(
                mainView.duplicateButton.rx.tap.asSignal().map { .duplicate },
                mainView.shareButton.rx.tap.asSignal().map { .share },
                mainView.deleteButton.rx.tap.asSignal().map { .delete }
            )
            .emit(to: Binder(self) { base, action in
                base.dismiss {
                    base.action(action)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        mainView.animateShow()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        dismiss()
    }
}

// MARK: Public
extension ClGroupMenuViewController {
    static func make(action: @escaping (ClGroupMenuButton.Action) -> Void) -> ClGroupMenuViewController {
        let vc = ClGroupMenuViewController(action: action)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension ClGroupMenuViewController {
    func dismiss(completion: (() -> Void)? = nil) {
        mainView.animateDismiss { [weak self] in
            self?.dismiss(animated: false) {
                completion?()
            }
        }
    }
}
