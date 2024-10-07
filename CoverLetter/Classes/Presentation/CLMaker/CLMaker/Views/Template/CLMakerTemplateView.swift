//
//  CLMakerTemplateView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 30.08.2024.
//

import UIKit

final class CLMakerTemplateView: CLMakerFlowView {
    lazy var collectionView = makeCollectionView()
    lazy var continueButton = makeContinueButton()
    
    private let finished: (CLTemplate) -> Void
    
    init(finished: @escaping (CLTemplate) -> Void) {
        self.finished = finished
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CLMakerTemplateView {
    func setup(elements: [CLMTemplatesCollectionElement]) {
        collectionView.setup(elements: elements)
    }
}

// MARK: Private
private extension CLMakerTemplateView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
    
    @objc
    func continueTapped() {
        let template = collectionView.elements.compactMap { iteractionElement -> CLTemplate? in
            guard case let .template(element) = iteractionElement else { return nil }
            return element.marked ? element.template : nil
        }.first
        guard let template else { return }
        
        finished(template)
    }
}

// MARK: Make constraints
private extension CLMakerTemplateView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: CGFloat.continueButtonHeight),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -CGFloat.continueButtonBottomConstaint)
        ])
    }
}

// MARK: Lazy initialization
private extension CLMakerTemplateView {
    func makeCollectionView() -> CLMTemplatesCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15.scale
        layout.minimumInteritemSpacing = 15.scale
        
        let view = CLMTemplatesCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets(
            t: 20.scale,
            l: 16.scale,
            b: CGFloat.continueButtonBottomConstaint + CGFloat.continueButtonHeight + 8.scale,
            r: 16.scale
        )
        view.showsVerticalScrollIndicator = false
        view.setContentOffset(CGPoint(x: 0, y: -20.scale), animated: false)
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

// MARK: Additional
private extension CGFloat {
    static let continueButtonBottomConstaint = ScreenSize.isIphoneXFamily ? 8.scale : 16.scale
    static let continueButtonHeight = 58.scale
}
