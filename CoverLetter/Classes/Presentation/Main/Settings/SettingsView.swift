//
//  SettingsView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

import UIKit

final class SettingsView: UIView {
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
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension SettingsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            termsOfUseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            termsOfUseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            termsOfUseButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24.scale),
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
    func makeLinkButton(entity: SettingsLinkButton.Entity) -> SettingsLinkButton {
        let view = SettingsLinkButton(entity: entity)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
