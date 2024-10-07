//
//  CVMRListInfoView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 26.08.2024.
//

import UIKit

final class CVMRListInfoView: UIView {
    enum Entity {
        case email, phone
    }
    
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    private let value: String
    private let entity: Entity
    
    init(value: String, entity: Entity) {
        self.value = value
        self.entity = entity
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CVMRListInfoView {
    func initialize() {
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: Make constraints
private extension CVMRListInfoView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 20.scale),
            iconView.heightAnchor.constraint(equalToConstant: 20.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMRListInfoView {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: entity.iconName)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main200)
            .font(Fonts.Nunito.semiBold(size: 17.scale))
            .lineHeight(23.19.scale)
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        
        let view = UILabel()
        view.attributedText = value.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension CVMRListInfoView.Entity {
    var iconName: String {
        switch self {
        case .email:
            return "CVMaker.Email"
        case .phone:
            return "CVMaker.Phone"
        }
    }
}
