//
//  MainCollectionCell.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

import UIKit

final class MainCollectionCell: UICollectionViewCell {
    var didTapMenu: (() -> Void)?
    
    lazy var backgroundImageView = makeBackgroudImageView()
    lazy var template1View = makeTemplateView()
    lazy var template2View = makeTemplateView()
    lazy var template2DimmedView = makeTemplate2Dimmed()
    lazy var templatesCountLabel = makeLabel()
    lazy var nameLabel = makeLabel()
    lazy var menuButton = makeMenuButton()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Nunito.bold(size: 15.scale))
        .lineHeight(20.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    private lazy var templatesCountAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Nunito.bold(size: 17.scale))
        .lineHeight(22.scale)
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
extension MainCollectionCell {
    func setup(resumeGroup: ResumeGroup) {
        let template1Identifier: (Bool, Int)? = {
            if let identifier = resumeGroup.cvs.first?.template.identifier.rawValue {
                return (true, identifier)
            } else if let identifier = resumeGroup.cls.first?.template.identifier.rawValue {
                return (false, identifier)
            }
            return nil
        }()
        
        let template2Identifier: (Bool, Int)? = {
            if let identifier = resumeGroup.cvs[safe: 1]?.template.identifier.rawValue {
                return (true, identifier)
            } else if let identifier = resumeGroup.cls[safe: 0]?.template.identifier.rawValue, identifier != template1Identifier?.1 {
                return (false, identifier)
            } else if let identifier = resumeGroup.cls[safe: 1]?.template.identifier.rawValue {
                return (false, identifier)
            }
            return nil
        }()
        
        template1View.isHidden = template1Identifier == nil
        template2View.isHidden = template2Identifier == nil
        
        if let identifier = template1Identifier {
            let imageName = (identifier.0 ? "CVTemplate" : "CLTemplate") + ".\(identifier.1 + 1)"
            template1View.image = UIImage(named: imageName)
        }
        
        if let identifier = template2Identifier {
            let imageName = (identifier.0 ? "CVTemplate" : "CLTemplate") + ".\(identifier.1 + 1)"
            template2View.image = UIImage(named: imageName)
        }
        
        let totalTemplates = resumeGroup.cvs.count + resumeGroup.cls.count
        
        template2DimmedView.isHidden = totalTemplates <= 2
        templatesCountLabel.isHidden = totalTemplates <= 2
        
        templatesCountLabel.attributedText = "+\(totalTemplates - 2)".attributed(with: templatesCountAttrs)
        
        nameLabel.attributedText = resumeGroup.name.attributed(with: nameAttrs)
    }
}

// MARK: Private
private extension MainCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func menuTapped() {
        didTapMenu?()
    }
}

// MARK: Make constraints
private extension MainCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            template1View.widthAnchor.constraint(equalToConstant: 63.scale),
            template1View.heightAnchor.constraint(equalToConstant: 89.scale),
            template1View.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 18.scale),
            template1View.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            template2View.widthAnchor.constraint(equalToConstant: 63.scale),
            template2View.heightAnchor.constraint(equalToConstant: 89.scale),
            template2View.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 92.scale),
            template2View.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            template2DimmedView.leadingAnchor.constraint(equalTo: template2View.leadingAnchor),
            template2DimmedView.trailingAnchor.constraint(equalTo: template2View.trailingAnchor),
            template2DimmedView.topAnchor.constraint(equalTo: template2View.topAnchor),
            template2DimmedView.bottomAnchor.constraint(equalTo: template2View.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            templatesCountLabel.centerXAnchor.constraint(equalTo: template2View.centerXAnchor),
            templatesCountLabel.centerYAnchor.constraint(equalTo: template2View.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 12.scale),
            nameLabel.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -30.scale),
            nameLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -11.scale)
        ])
        
        NSLayoutConstraint.activate([
            menuButton.widthAnchor.constraint(equalToConstant: 16.scale),
            menuButton.heightAnchor.constraint(equalToConstant: 16.scale),
            menuButton.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: -11.scale),
            menuButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MainCollectionCell {
    func makeBackgroudImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.image = UIImage(named: "Main.Group")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTemplateView() -> UIImageView {
        let view = UIImageView()
        view.layer.borderWidth = 0.55.scale
        view.layer.borderColor = Appearance.main200.withAlphaComponent(0.8).cgColor
        view.layer.cornerRadius = 6.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTemplate2Dimmed() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 6.scale
        view.backgroundColor = Appearance.mono100.withAlphaComponent(0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeMenuButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Main.Menu"), for: .normal)
        view.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
