//
//  RWWCViewController.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 29.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class RWWCViewController: UIViewController {
    enum Entity {
        case cv, cl
    }
    
    lazy var mainView = RWWCView()

    private lazy var disposeBag = DisposeBag()
    
    private let select: ((Entity) -> Void)
    
    private init(select: @escaping ((Entity) -> Void)) {
        self.select = select
        
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
        
        Signal
            .merge(
                mainView.cvButton.rx.tap.map { Entity.cv }.asSignal(onErrorSignalWith: .never()),
                mainView.clButton.rx.tap.map { Entity.cl }.asSignal(onErrorSignalWith: .never())
            )
            .emit(to: Binder(self) { base, entity in
                base.dismiss {
                    base.select(entity)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateShow()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        dismiss()
    }
}

// MARK: Make
extension RWWCViewController {
    static func make(select: @escaping ((Entity) -> Void)) -> RWWCViewController {
        let vc = RWWCViewController(select: select)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension RWWCViewController {
    func animateShow() {
        mainView.containerYConstraint.isActive = false
        mainView.containerYConstraint = mainView.container.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        mainView.containerYConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0.6
            self?.mainView.layoutIfNeeded()
        })
    }

    func dismiss(completion: (() -> Void)? = nil) {
        animateDismiss { [weak self] in
            self?.dismiss(animated: false) {
                completion?()
            }
        }
    }
    
    func animateDismiss(completion: @escaping (() -> Void)) {
        mainView.containerYConstraint.isActive = false
        mainView.containerYConstraint = mainView.container.topAnchor.constraint(equalTo: mainView.bottomAnchor)
        mainView.containerYConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0
            self?.mainView.layoutIfNeeded()
        }, completion: { result in
            completion()
        })
    }
}
