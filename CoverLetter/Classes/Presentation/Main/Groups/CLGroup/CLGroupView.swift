//
//  CLGroupView.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 08.10.2024.
//

import UIKit

final class CLGroupView: GradientView {
    lazy var backButton = makeBackButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var collectionView = makeCollectionView()
    lazy var createNewButton = makeCreateNewButton()
    
    private let title: String
    
    init(title: String) {
        self.title = title
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CLGroupView {
    func initialize() {
        gradientLayer.colors = [
            Appearance.custom_f7f3ed.cgColor,
            Appearance.mono100.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    }
}

// MARK: Make constraints
private extension CLGroupView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24.scale),
            backButton.heightAnchor.constraint(equalToConstant: 24.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 65.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale),
            collectionView.bottomAnchor.constraint(equalTo: createNewButton.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            createNewButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            createNewButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            createNewButton.heightAnchor.constraint(equalToConstant: 58.scale),
            createNewButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CLGroupView {
    func makeBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "CLGroup.Back"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semibold(size: 17.scale))
            .lineHeight(22.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> CLGroupCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15.scale
        layout.minimumInteritemSpacing = 15.scale
        layout.itemSize = CGSize(width: 172.scale, height: 242.scale)
        
        let view = CLGroupCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(vertical: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -16.scale), animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCreateNewButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.custom_fdfdfd)
            .font(Fonts.Inter.semibold(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("CLGroup.CreateNew".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = Appearance.custom_ed6f00
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
