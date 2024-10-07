//
//  CVMICollectionInterestCell.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

import UIKit

final class CVMICollectionInterestCell: UICollectionViewCell {
    lazy var label = makeLabel()
    
    private lazy var normalAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.4))
        .font(Fonts.Nunito.semiBold(size: 17.scale))
        .lineHeight(23.scale)
        .textAlignment(.center)
    private lazy var selectedAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Nunito.semiBold(size: 17.scale))
        .lineHeight(23.scale)
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
extension CVMICollectionInterestCell {
    func setup(element: CVMICollectionInterestElement) {
        label.attributedText = element.interest.name.attributed(with: element.marked ? selectedAttrs : normalAttrs)
        
        contentView.backgroundColor = element.marked ? Appearance.main200 : Appearance.mono100
        
        contentView.layer.shadowColor = element.marked ? UIColor.clear.cgColor : Appearance.mono200.withAlphaComponent(0.4).cgColor
        contentView.layer.shadowOpacity = element.marked ? 0 :  0.1
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowRadius = element.marked ? 0 : 4.scale
    }
}

// MARK: Private
private extension CVMICollectionInterestCell {
    func initialize() {
        backgroundColor = UIColor.clear
        
        contentView.layer.cornerRadius = 12.scale
        contentView.layer.masksToBounds = true
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension CVMICollectionInterestCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMICollectionInterestCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
