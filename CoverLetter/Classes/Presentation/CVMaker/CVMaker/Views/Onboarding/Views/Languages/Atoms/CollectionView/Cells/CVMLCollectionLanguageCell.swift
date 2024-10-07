//
//  CVMLCollectionLanguageCell.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

import UIKit

final class CVMLCollectionLanguageCell: UICollectionViewCell {
    var didTapLevel: (() -> Void)?
    
    lazy var container = makeContainer()
    lazy var languageLabel = makeLabel()
    lazy var levelButton = makeTapButton()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Nunito.semiBold(size: 17.scale))
        .lineHeight(23.scale)
        .textAlignment(.left)
    private lazy var levelAttrs = TextAttributes()
        .textColor(UIColor(integralRed: 78, green: 105, blue: 254))
        .font(Fonts.Nunito.semiBold(size: 17.scale))
        .lineHeight(23.scale)
        .textAlignment(.right)
    
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
extension CVMLCollectionLanguageCell {
    func setup(element: Language) {
        languageLabel.attributedText = element.name.attributed(with: nameAttrs)
        levelButton.setAttributedTitle(element.level.localized.attributed(with: levelAttrs), for: .normal)
    }
}

// MARK: Private
private extension CVMLCollectionLanguageCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func levelTapped() {
        didTapLevel?()
    }
}

// MARK: Make constraints
private extension CVMLCollectionLanguageCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.widthAnchor.constraint(equalToConstant: 361.scale),
            container.heightAnchor.constraint(equalToConstant: 59.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            languageLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            languageLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            levelButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            levelButton.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMLCollectionLanguageCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
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
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTapButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(levelTapped), for: .touchUpInside)
        container.addSubview(view)
        return view
    }
}

// MARK: Additional
private extension Language.Level {
    var localized: String {
        switch self {
        case .beginner:
            return "Language.Beginner".localized
        case .preIntermediate:
            return "Language.PreIntermediate".localized
        case .intermediate:
            return "Language.Intermediate".localized
        case .upperIntermediate:
            return "Language.UpperIntermediate".localized
        case .advanced:
            return "Language.Advanced".localized
        case .proficient:
            return "Language.Proficient".localized
        }
    }
}
