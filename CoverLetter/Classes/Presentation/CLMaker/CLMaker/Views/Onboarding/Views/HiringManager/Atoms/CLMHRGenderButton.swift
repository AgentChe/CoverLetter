//
//  CLMHRGenderButton.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

import UIKit

final class CLMHRGenderButton: UIButton {
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    private let gender: CLHiringManager.Gender
    
    init(gender: CLHiringManager.Gender) {
        self.gender = gender
        
        super.init(frame: .zero)
        
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semibold(size: 17.scale))
        setAttributedTitle(gender.title.attributed(with: attrs), for: .normal)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CLMHRGenderButton {
    func initialize() {
        layer.cornerRadius = 20.scale
        layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = 4.scale
        backgroundColor = Appearance.mono100
        contentHorizontalAlignment = .left
        titleEdgeInsets = UIEdgeInsets(l: 16.scale)
    }
    
    func update() {
        layer.borderWidth = marked ? 2.scale : 0
        layer.borderColor = marked ? Appearance.custom_ed6f00.cgColor : UIColor.clear.cgColor
    }
}

// MARK: Additional
private extension CLHiringManager.Gender {
    var title: String {
        switch self {
        case .male:
            return "CLMaker.HiringManager.Gender.Male".localized
        case .female:
            return "CLMaker.HiringManager.Gender.Female".localized
        }
    }
}
