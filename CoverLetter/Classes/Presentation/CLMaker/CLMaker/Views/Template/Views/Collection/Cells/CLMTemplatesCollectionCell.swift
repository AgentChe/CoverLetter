//
//  CLMTemplatesCollectionCell.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 30.08.2024.
//

import UIKit

final class CLMTemplatesCollectionCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var templateView = makeTemplateView()
    lazy var selectedView = makeSelectedView()
    
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
extension CLMTemplatesCollectionCell {
    func setup(element: CLMTemplatesCollectionTemplateElement) {
        let templateImageName = "CLTemplate.\(element.template.identifier.rawValue + 1)"
        templateView.image = UIImage(named: templateImageName)
        
        selectedView.isHidden = !element.marked
        
        container.layer.borderWidth = element.marked ? 3.scale : 0
        container.layer.borderColor = element.marked ? Appearance.custom_ed6f00.cgColor : UIColor.clear.cgColor
    }
}

// MARK: Private
private extension CLMTemplatesCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension CLMTemplatesCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            templateView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            templateView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            templateView.topAnchor.constraint(equalTo: container.topAnchor),
            templateView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            selectedView.widthAnchor.constraint(equalToConstant: 20.scale),
            selectedView.heightAnchor.constraint(equalToConstant: 20.scale),
            selectedView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12.scale),
            selectedView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CLMTemplatesCollectionCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 16.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTemplateView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 16.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSelectedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "CLMaker.Template.Selected")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
