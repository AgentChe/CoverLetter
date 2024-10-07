//
//  CVMPSCollectionSkillCell.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

import UIKit

final class CVMPSCollectionSkillCell: UICollectionViewCell {
    var didTapDelete: (() -> Void)?
    
    lazy var label = makeLabel()
    lazy var deleteButton = makeDeleteButton()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Nunito.semiBold(size: 17.scale))
        .textAlignment(.left)
    
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
extension CVMPSCollectionSkillCell {
    func setup(element: ProfessionalSkill) {
        label.attributedText = element.name.attributed(with: attrs)
    }
}

// MARK: Private
private extension CVMPSCollectionSkillCell {
    func initialize() {
        backgroundColor = UIColor.clear
        
        contentView.backgroundColor = Appearance.mono100
        contentView.layer.cornerRadius = 12.scale
        contentView.layer.masksToBounds = true
        contentView.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowRadius = 4.scale
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func deleteTapped() {
        didTapDelete?()
    }
}

// MARK: Make constraints
private extension CVMPSCollectionSkillCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -42.scale)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 12.scale),
            deleteButton.heightAnchor.constraint(equalToConstant: 12.scale),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMPSCollectionSkillCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeDeleteButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "CVMaker.DeleteEntity2"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
