//
//  CVMGIAboutYourselfTipCell.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

import UIKit

final class CVMGIAboutYourselfTipCell: UIView {
    lazy var circleView = makeCircleView()
    lazy var label = makeLabel()
    
    private let text: String
    
    init(text: String) {
        self.text = text
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension CVMGIAboutYourselfTipCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalToConstant: 4.scale),
            circleView.heightAnchor.constraint(equalToConstant: 4.scale),
            circleView.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -8.scale),
            circleView.topAnchor.constraint(equalTo: label.topAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMGIAboutYourselfTipCell {
    func makeCircleView() -> CircleView {
        let view = CircleView()
        view.backgroundColor = Appearance.mono200.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.6))
            .font(Fonts.SFPro.regular(size: 17.scale))
            .lineHeight(20.29.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = text.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
