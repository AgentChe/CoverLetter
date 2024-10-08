//
//  CLsGroupsTableCell.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 08.10.2024.
//

import UIKit

final class CLsGroupsTableCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var placeholderImageView = makePlaceholderImageView()
    lazy var gradientView = makeGradientView()
    lazy var nameLabel = makeNameLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Inter.bold(size: 23.scale))
        .lineHeight(28.scale)
        .textAlignment(.center)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CLsGroupsTableCell {
    func setup(clGroup: CLsGroup) {
        nameLabel.attributedText = clGroup.name.attributed(with: attrs)
    }
}

// MARK: Private
private extension CLsGroupsTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        contentView.layer.masksToBounds = true
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension CLsGroupsTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 178.scale)
        ])
        
        NSLayoutConstraint.activate([
            placeholderImageView.widthAnchor.constraint(equalToConstant: 272.scale),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 178.scale),
            placeholderImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            placeholderImageView.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 54.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            nameLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -23.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CLsGroupsTableCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePlaceholderImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "CLsGroups.PlaceholderItem")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeGradientView() -> GradientView {
        let view = GradientView()
        view.gradientLayer.colors = [
            Appearance.mono100.withAlphaComponent(0).cgColor,
            Appearance.mono100.cgColor
        ]
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
