//
//  SelectField.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

import UIKit

final class SelectField: UIView {
    var action: (() -> Void)?
    
    var value: String? {
        didSet {
            update()
        }
    }
    
    lazy var titleLabel = makeTitleLabel()
    lazy var container = makeContainer()
    lazy var contentLabel = makeLabel()
    
    private lazy var contentAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Nunito.semiBold(size: 17.scale))
        .lineHeight(23.19.scale)
        .textAlignment(.left)
    private lazy var placeholderAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.4))
        .font(Fonts.Nunito.semiBold(size: 17.scale))
        .lineHeight(23.19.scale)
        .textAlignment(.left)
    
    private let title: String
    private let placeholder: String
    
    init(title: String, placeholder: String? = nil) {
        self.title = title
        self.placeholder = placeholder ?? title
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SelectField {
    func initialize() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        container.isUserInteractionEnabled = true
        container.addGestureRecognizer(tapGesture)
    }
    
    func update() {
        let attrs = value == nil ? placeholderAttrs : contentAttrs
        let text = value ?? placeholder
        contentLabel.attributedText = text.attributed(with: attrs)
    }
    
    @objc
    func tapped() {
        action?()
    }
}

// MARK: Make constraints
private extension SelectField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.scale),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 59.scale)
        ])
        
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            contentLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            contentLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SelectField {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.4))
            .font(Fonts.Nunito.semiBold(size: 10.scale))
            .lineHeight(13.64.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 10.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.backgroundColor = Appearance.mono100
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
