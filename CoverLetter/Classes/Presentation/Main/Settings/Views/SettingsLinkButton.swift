//
//  SettingsLinkButton.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

import UIKit
import RxCocoa

final class SettingsLinkButton: UIButton {
    enum Entity {
        case termsOfUse, privacyPolicy, contactUs
    }
    
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    lazy var arrowView = makeArrowView()
    
    private let entity: Entity
    
    init(entity: Entity) {
        self.entity = entity
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SettingsLinkButton {
    var didTapLink: Signal<URL> {
        rx.tap.compactMap { [weak self] void -> URL? in
            guard let self else { return nil }
            
            switch entity {
            case .termsOfUse:
                return GlobalDefinitions.termsOfServiceUrl
            case .privacyPolicy:
                return GlobalDefinitions.privacyPolicyUrl
            case .contactUs:
                return GlobalDefinitions.contactUsUrl
            }
        }
        .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Private
private extension SettingsLinkButton {
    func initialize() {
        layer.cornerRadius = 16.scale
        layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = 4.scale
        backgroundColor = Appearance.mono100
    }
}

// MARK: Make constraints
private extension SettingsLinkButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 24.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 24.scale),
            arrowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsLinkButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: entity.iconName)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semibold(size: 15.scale))
            .lineHeight(18.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = entity.title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Settings.Arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

private extension SettingsLinkButton.Entity {
    var iconName: String {
        switch self {
        case .termsOfUse:
            return "Settings.TermsOfUs"
        case .privacyPolicy:
            return "Settings.PrivacyPolicy"
        case .contactUs:
            return "Settings.ContactUs"
        }
    }
    
    var title: String {
        switch self {
        case .termsOfUse:
            return "Settings.TermsOfUse".localized
        case .privacyPolicy:
            return "Settings.PrivacyPolicy".localized
        case .contactUs:
            return "Settings.ContactUs".localized
        }
    }
}
