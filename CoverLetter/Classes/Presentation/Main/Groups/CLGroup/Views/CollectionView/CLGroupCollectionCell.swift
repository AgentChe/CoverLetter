//
//  CLGroupCollectionCell.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 08.10.2024.
//

import UIKit

final class CLGroupCollectionCell: UICollectionViewCell {
    var didMenuTap: (() -> Void)?
    
    lazy var templateView = makeTemplateView()
    lazy var menuButton = makeMenuButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CLGroupCollectionCell {
    func setup(element: CL) {
        let imageName = "CLTemplate.\(element.template.identifier.rawValue + 1)"
        templateView.image = UIImage(named: imageName)
    }
}

// MARK: Private
private extension CLGroupCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func menuTapped() {
        didMenuTap?()
    }
}

// MARK: Make constraints
private extension CLGroupCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            templateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            templateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            templateView.topAnchor.constraint(equalTo: contentView.topAnchor),
            templateView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            menuButton.widthAnchor.constraint(equalToConstant: 24.scale),
            menuButton.heightAnchor.constraint(equalToConstant: 24.scale),
            menuButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.scale),
            menuButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CLGroupCollectionCell {
    func makeTemplateView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeMenuButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.setImage(UIImage(named: "CLGroup.Menu"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
