//
//  CVMTOVCell.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

import UIKit

final class CVMTOVCell: UIView {
    enum Entity {
        case friendly, formal, funny
    }
    
    lazy var titleLabel = makeTitleLabel()
    lazy var switchView = makeSwitch()
    lazy var container = makeContainer()
    lazy var exampleIconView = makeExampleIconView()
    lazy var exampleTitleLabel = makeExampleTitleLabel()
    lazy var exampleLabel = makeExampleLabel()
    lazy var bestRegardsLabel = makeBestRegardsLabel()
    
    private let entity: Entity
    
    private let title: String
    private let example: String
    private let bestRegards: String
    
    init(entity: Entity) {
        self.entity = entity
        
        let args = entity.args
        self.title = args.title
        self.example = args.example
        self.bestRegards = args.bestRegards
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CVMTOVCell {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension CVMTOVCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            switchView.widthAnchor.constraint(equalToConstant: 51.scale),
            switchView.heightAnchor.constraint(equalToConstant: 31.scale),
            switchView.trailingAnchor.constraint(equalTo: trailingAnchor),
            switchView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor, constant: 47.scale),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            exampleIconView.widthAnchor.constraint(equalToConstant: 24.scale),
            exampleIconView.heightAnchor.constraint(equalToConstant: 16.scale),
            exampleIconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            exampleIconView.centerYAnchor.constraint(equalTo: exampleTitleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            exampleTitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 48.scale),
            exampleTitleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 17.scale)
        ])
        
        NSLayoutConstraint.activate([
            exampleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            exampleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            exampleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 45.scale)
        ])
        
        NSLayoutConstraint.activate([
            bestRegardsLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            bestRegardsLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            bestRegardsLabel.topAnchor.constraint(equalTo: exampleLabel.bottomAnchor, constant: 8.scale),
            bestRegardsLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -17.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMTOVCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.semibold(size: 21.scale))
            .lineHeight(25.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSwitch() -> UISwitch {
        let view = UISwitch()
        view.thumbTintColor = Appearance.mono100
        view.tintColor = Appearance.mono200.withAlphaComponent(0.2)
        view.onTintColor = UIColor(integralRed: 52, green: 199, blue: 89)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.custom_ed6f00.withAlphaComponent(0.1)
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeExampleIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "CLMaker.ToneOfVoice.Example")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeExampleTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.custom_ed6f00)
            .font(Fonts.Inter.semibold(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "CLMaker.ToneOfVoice.Example".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeExampleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.6))
            .font(Fonts.Inter.regular(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = example.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeBestRegardsLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.6))
            .font(Fonts.SFPro.ultraLight(size: 15.scale))
            .lineHeight(18.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = bestRegards.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}

// MARK: Additional
private extension CVMTOVCell.Entity {
    var args: (title: String, example: String, bestRegards: String) {
        switch self {
        case .friendly:
            return (
                title: "CLMaker.ToneOfVoice.Friendly.Title".localized,
                example: "CLMaker.ToneOfVoice.Friendly.Example".localized,
                bestRegards: "CLMaker.ToneOfVoice.Friendly.BestRegards".localized
            )
        case .formal:
            return (
                title: "CLMaker.ToneOfVoice.Formal.Title".localized,
                example: "CLMaker.ToneOfVoice.Formal.Example".localized,
                bestRegards: "CLMaker.ToneOfVoice.Formal.BestRegards".localized
            )
        case .funny:
            return (
                title: "CLMaker.ToneOfVoice.Funny.Title".localized,
                example: "CLMaker.ToneOfVoice.Funny.Example".localized,
                bestRegards: "CLMaker.ToneOfVoice.Funny.BestRegards".localized
            )
        }
    }
}
