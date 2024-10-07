//
//  CVMakerSingleEntityView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.05.2024.
//

import UIKit

final class CVMakerSingleEntityView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var textLabel = makeSubTitleLabel()
    lazy var noActionButton = makeActionButton(text: noActionTitle)
    lazy var yesActionButton = makeActionButton(text: yesActionTitle)
    
    private let title: String
    private let text: String
    private let noActionTitle: String
    private let yesActionTitle: String
    private let noAction: (CVMakerSingleEntityView) -> Void
    private let yesAction: (CVMakerSingleEntityView) -> Void
    
    init(
        title: String,
        text: String,
        noActionTitle: String = "CVMaker.SingleEntity.NoAction".localized,
        yesActionTitle: String = "CVMaker.SingleEntity.YesAction".localized,
        noAction: @escaping ((CVMakerSingleEntityView) -> Void),
        yesAction: @escaping ((CVMakerSingleEntityView) -> Void)
    ) {
        self.title = title
        self.text = text
        self.noActionTitle = noActionTitle
        self.yesActionTitle = yesActionTitle
        self.noAction = noAction
        self.yesAction = yesAction
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CVMakerSingleEntityView {
    func initialize() {
        noActionButton.addTarget(self, action: #selector(noActionTapped), for: .touchUpInside)
        yesActionButton.addTarget(self, action: #selector(yesActionTapped), for: .touchUpInside)
    }
    
    @objc
    func noActionTapped() {
        noAction(self)
    }
    
    @objc
    func yesActionTapped() {
        yesAction(self)
    }
}

// MARK: Make constraints
private extension CVMakerSingleEntityView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            noActionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            noActionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            noActionButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 28.scale),
            noActionButton.heightAnchor.constraint(equalToConstant: 59.scale)
        ])
        
        NSLayoutConstraint.activate([
            yesActionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            yesActionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            yesActionButton.topAnchor.constraint(equalTo: noActionButton.bottomAnchor, constant: 16.scale),
            yesActionButton.heightAnchor.constraint(equalToConstant: 59.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMakerSingleEntityView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.bold(size: 30.scale))
            .lineHeight(34.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = title.localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.regular(size: 17.scale))
            .lineHeight(20.29.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = text.localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeActionButton(text: String) -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Nunito.semiBold(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle(text.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 12.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
