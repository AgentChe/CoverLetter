//
//  CVMGIAboutYourselfTipsView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

import UIKit

final class CVMGIAboutYourselfTipsView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(number: 1)
    lazy var cell2 = makeCell(number: 2)
    lazy var cell3 = makeCell(number: 3)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension CVMGIAboutYourselfTipsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 37.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 2.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: 2.scale),
            cell3.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMGIAboutYourselfTipsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main300)
            .font(Fonts.SFPro.semiBold(size: 17.scale))
            .lineHeight(20.29.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "CVMaker.AboutYourself.TipsTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(number: Int) -> CVMGIAboutYourselfTipCell {
        let view = CVMGIAboutYourselfTipCell(text: "CVMaker.AboutYourself.Tip\(number)".localized)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
