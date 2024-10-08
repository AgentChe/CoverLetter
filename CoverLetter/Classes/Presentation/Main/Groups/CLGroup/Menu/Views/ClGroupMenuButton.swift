//
//  ClGroupMenuButton.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 08.10.2024.
//

import UIKit

final class ClGroupMenuButton: UIButton {
    enum Action {
        case duplicate
        case share
        case delete
    }
    
    lazy var label = makeLabel()
    lazy var iconView = makeIconView()
    lazy var separator = makeSeparator()
    
    private let action: Action
    
    init(action: Action) {
        self.action = action
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ClGroupMenuButton {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension ClGroupMenuButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 11.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11.scale)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ClGroupMenuButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(action == .delete ? Appearance.custom_ff3b30 : Appearance.mono200)
            .font(Fonts.SFPro.regular(size: 17.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = action.title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: action.iconName)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.isHidden = action == .delete
        view.backgroundColor = UIColor(integralRed: 128, green: 128, blue: 128, alpha: 0.55)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension ClGroupMenuButton.Action {
    var title: String {
        switch self {
        case .duplicate:
            return "CLGroup.Duplicate".localized
        case .share:
            return "CLGroup.Share".localized
        case .delete:
            return "CLGroup.Delete".localized
        }
    }
    
    var iconName: String {
        switch self {
        case .duplicate:
            return "CLGroup.Duplicate"
        case .share:
            return "CLGroup.Share"
        case .delete:
            return "CLGroup.Delete"
        }
    }
}
