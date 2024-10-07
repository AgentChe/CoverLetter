//
//  WrapperController.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 24.05.2024.
//

import UIKit
import RxSwift

protocol WrappedView where Self: UIView {
    var didChangeCanComplete: ((Bool) -> Void)? { get set }
    func complete()
}

final class WrapperController: UIViewController {
    private lazy var closeButton: TapAreaButton = {
        let closeButton = TapAreaButton()
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "Wrapper.Close"), for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        return closeButton
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets()
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        return scrollView
    }()
    
    private lazy var saveButton: UIButton = {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Nunito.semiBold(size: 17.scale))
        
        let saveButton = UIButton()
        saveButton.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        saveButton.layer.cornerRadius = 12.scale
        saveButton.backgroundColor = Appearance.main200
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        return saveButton
    }()
    
    private lazy var disposeBag = DisposeBag()
    
    private let wrappedView: WrappedView
    
    private init(wrappedView: WrappedView) {
        self.wrappedView = wrappedView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        makeConstraints()
        
        wrappedView.didChangeCanComplete = { [weak self] enable in
            self?.saveButton.alpha = enable ? 1 : 0.4
            self?.saveButton.isEnabled = enable
        }
        
        closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true) {
                    base.wrappedView.complete()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension WrapperController {
    static func make(wrappedView: WrappedView) -> WrapperController {
        let vc = WrapperController(wrappedView: wrappedView)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Privates
private extension WrapperController {
    func initialize() {
        view.backgroundColor = Appearance.main100
        
        scrollView.addSubview(wrappedView)
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11.scale)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: closeButton.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            wrappedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.scale),
            wrappedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.scale),
            wrappedView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            wrappedView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            wrappedView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16.scale),
            wrappedView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.scale),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 58.scale),
            saveButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -16.scale)
        ])
    }
}
