//
//  CVMPSCollectionAddCell.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

import UIKit

final class CVMPSCollectionAddCell: UICollectionViewCell {
    var didTap: (() -> Void)?
    
    lazy var button = makeButton()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.main200)
        .font(Fonts.Nunito.semiBold(size: 17.scale))
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
extension CVMPSCollectionAddCell {
    func setup(text: String) {
        button.setAttributedTitle(text.attributed(with: attrs), for: .normal)
    }
}

// MARK: Private
private extension CVMPSCollectionAddCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func tapped() {
        didTap?()
    }
}

// MARK: Make constraints
private extension CVMPSCollectionAddCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.scale),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 59.scale),
            button.widthAnchor.constraint(equalToConstant: 360.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMPSCollectionAddCell {
    func makeButton() -> DottedButton {
        let view = DottedButton()
        view.backgroundColor = UIColor.clear
        view.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
