//
//  RWWCView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 29.08.2024.
//

import UIKit

final class RWWCView: UIView {
    lazy var dimmedView = makeDimmedView()
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var cvButton = makeCVButton()
    lazy var clButton = makeCLButton()
    
    lazy var containerYConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension RWWCView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dimmedView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        containerYConstraint = container.topAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            containerYConstraint,
            container.heightAnchor.constraint(equalToConstant: 320.scale),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            cvButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            cvButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            cvButton.heightAnchor.constraint(equalToConstant: 58.scale),
            cvButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            clButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            clButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            clButton.heightAnchor.constraint(equalToConstant: 58.scale),
            clButton.topAnchor.constraint(equalTo: cvButton.bottomAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RWWCView {
    func makeDimmedView() -> UIView {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 20.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Nunito.extraBold(size: 25.scale))
            .lineHeight(34.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "ResumeGroup.RWWC.Title".localized.attributed(with: attrs)
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCVButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Nunito.semiBold(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("ResumeGroup.RWWC.CV".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeCLButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Nunito.semiBold(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("ResumeGroup.RWWC.CL".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
