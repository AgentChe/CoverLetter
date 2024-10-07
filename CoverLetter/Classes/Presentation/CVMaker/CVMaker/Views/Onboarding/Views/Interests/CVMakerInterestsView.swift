//
//  CVMakerInterestsView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

import UIKit
import RxSwift

final class CVMakerInterestsView: UIView {
    lazy var collectionView = makeCollectionView()
    lazy var continueButton = makeContinueButton()
    
    private let bind: (([Interest]) -> Void)
    private let flowFinished: (() -> Void)
    
    private lazy var contentManager = ContentManager()
    
    private var disposable: Disposable?
    
    init(
        bind: @escaping (([Interest]) -> Void),
        flowFinished: @escaping (() -> Void)
    ) {
        self.bind = bind
        self.flowFinished = flowFinished
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CVMakerInterestsView {
    func setup(interests: [Interest]) {
        disposable?.dispose()
        
        disposable = contentManager
            .obtainInterests()
            .asDriver(onErrorJustReturn: [])
            .drive(Binder(collectionView) { base, allInterests in
                let elements: [CVMICollectionElement] = [.header] + allInterests.map { .interest(CVMICollectionInterestElement(
                    interest: $0,
                    marked: interests.contains($0)
                )) }
                base.setup(elements: elements)
            })
    }
}

// MARK: Private
private extension CVMakerInterestsView {
    @objc
    func continueTapped() {
        let interests = collectionView.elements.compactMap { element -> Interest? in
            guard case let .interest(interest) = element else { return nil }
            return interest.marked ? interest.interest : nil
        }
        bind(interests)
        
        flowFinished()
    }
}

// MARK: Make constraints
private extension CVMakerInterestsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 58.scale),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -8.scale : -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMakerInterestsView {
    func makeCollectionView() -> CVMICollectionView {
        let layout = CVMPSCollectionLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12.scale
        layout.minimumInteritemSpacing = 12.scale
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let view = CVMICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets(vertical: 32.scale, horizontal: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -32.scale), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Nunito.semiBold(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 12.scale
        view.backgroundColor = Appearance.main200
        view.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
