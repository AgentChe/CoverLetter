//
//  SettingsView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

import UIKit

final class SettingsView: UIView {
    lazy var roundedView = makeRoundedView()
    lazy var titleLabel = makeTitleLabel()
    lazy var termsOfUseButton = makeLinkButton(entity: .termsOfUse)
    lazy var privacyPolicyButton = makeLinkButton(entity: .privacyPolicy)
    lazy var contactUsButton = makeLinkButton(entity: .contactUs)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SettingsView {
    func initialize() {
        backgroundColor = Appearance.mono100
    }
}

// MARK: Make constraints
private extension SettingsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            roundedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            roundedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            roundedView.topAnchor.constraint(equalTo: topAnchor, constant: 54.scale),
            roundedView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: roundedView.topAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsOfUseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            termsOfUseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            termsOfUseButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.scale),
            termsOfUseButton.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            privacyPolicyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            privacyPolicyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            privacyPolicyButton.topAnchor.constraint(equalTo: termsOfUseButton.bottomAnchor, constant: 12.scale),
            privacyPolicyButton.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            contactUsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            contactUsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            contactUsButton.topAnchor.constraint(equalTo: privacyPolicyButton.bottomAnchor, constant: 12.scale),
            contactUsButton.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsView {
    func makeRoundedView() -> GradientView {
        let view = GradientView()
        view.gradientLayer.colors = [
            Appearance.custom_f7f3ed.cgColor,
            Appearance.mono100.cgColor
        ]
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.cornerRadius = 30.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.bold(size: 25.scale))
            .lineHeight(34.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Settings.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLinkButton(entity: SettingsLinkButton.Entity) -> SettingsLinkButton {
        let view = SettingsLinkButton(entity: entity)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
