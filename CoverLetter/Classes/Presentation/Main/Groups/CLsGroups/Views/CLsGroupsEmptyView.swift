//
//  CLsGroupsEmptyView.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 08.10.2024.
//

import UIKit

final class CLsGroupsEmptyView: UIView {
    lazy var imageView = makeImageView()
    lazy var textLabel = makeTextLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initiailize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CLsGroupsEmptyView {
    func initiailize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension CLsGroupsEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 126.scale),
            imageView.heightAnchor.constraint(equalToConstant: 157.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 165.scale),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CLsGroupsEmptyView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "CLsGroups.Empty")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.medium(size: 19.scale))
            .lineHeight(23.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "CLsGroups.Empty.Text".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
