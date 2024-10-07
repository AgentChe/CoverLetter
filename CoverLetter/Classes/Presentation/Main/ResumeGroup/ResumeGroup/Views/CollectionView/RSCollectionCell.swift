//
//  RSCollectionCell.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 29.08.2024.
//

import UIKit

final class RSCollectionCell: UICollectionViewCell {
    lazy var templateView = makeTemplateView()
    lazy var titleLabel = makeLabel()
    lazy var dateLabel = makeLabel()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Nunito.bold(size: 21.scale))
        .lineHeight(29.scale)
        .textAlignment(.center)
    private lazy var dateAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.5))
        .font(Fonts.Nunito.medium(size: 15.scale))
        .lineHeight(20.scale)
        .textAlignment(.center)
    
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
extension RSCollectionCell {
    func setup(element: RSCollectionElement) {
        templateView.image = UIImage(named: element.templateName)
        titleLabel.attributedText = element.title.attributed(with: titleAttrs)
        dateLabel.attributedText = element.date.attributed(with: dateAttrs)
    }
}

// MARK: Private
private extension RSCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension RSCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            templateView.widthAnchor.constraint(equalToConstant: 345.scale),
            templateView.heightAnchor.constraint(equalToConstant: 488.scale),
            templateView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            templateView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 29.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: templateView.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RSCollectionCell {
    func makeTemplateView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 16.scale
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
        contentView.addSubview(view)
        return view
    }
}
