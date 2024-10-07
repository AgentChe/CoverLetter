//
//  DottedButton.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 24.05.2024.
//

import UIKit

final class DottedButton: UIButton {
    private lazy var dottedLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = Appearance.main200.cgColor
        shapeLayer.lineWidth = 2.scale
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [
            NSNumber(floatLiteral: 6.scale),
            NSNumber(floatLiteral: 3.scale)
        ]
        layer.addSublayer(shapeLayer)
        return shapeLayer
    }()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.main200)
        .font(Fonts.Nunito.semiBold(size: 17.scale))
    
    init(title: String = "CVMaker.AddMore".localized) {
        super.init(frame: .zero)
        
        setAttributedTitle(title.attributed(with: attrs), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dottedLayer.bounds = bounds
        dottedLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        dottedLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12.scale).cgPath
    }
}
