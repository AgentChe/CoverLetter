//
//  CLMakerToneOfVoiceView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

import UIKit

final class CLMakerToneOfVoiceView: UIView {
    lazy var scrollView = makeScrollView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var friendlyCell = makeCell(entity: .friendly)
    lazy var formalCell = makeCell(entity: .formal)
    lazy var funnyCell = makeCell(entity: .funny)
    lazy var continueButton = makeContinueButton()
    
    private let bind: (CLToneOfVoice) -> Void
    private let flowFinished: () -> Void
    
    init(
        bind: @escaping (CLToneOfVoice) -> Void,
        flowFinished: @escaping () -> Void
    ) {
        self.bind = bind
        self.flowFinished = flowFinished
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CLMakerToneOfVoiceView {
    func setup(toneOfVoice: CLToneOfVoice?) {
        friendlyCell.switchView.setOn(toneOfVoice?.friendly ?? false, animated: false)
        formalCell.switchView.setOn(toneOfVoice?.formal ?? false, animated: false)
        funnyCell.switchView.setOn(toneOfVoice?.funny ?? false, animated: false)
    }
}

// MARK: Private
private extension CLMakerToneOfVoiceView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func continueTapped() {
        let toneOfVoice = CLToneOfVoice(
            friendly: friendlyCell.switchView.isOn,
            formal: formalCell.switchView.isOn,
            funny: funnyCell.switchView.isOn
        )
        bind(toneOfVoice)
        
        flowFinished()
    }
}

// MARK: Make constraints
private extension CLMakerToneOfVoiceView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            friendlyCell.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            friendlyCell.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            friendlyCell.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 28.scale)
        ])
        
        NSLayoutConstraint.activate([
            formalCell.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            formalCell.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            formalCell.topAnchor.constraint(equalTo: friendlyCell.bottomAnchor, constant: 28.scale)
        ])
        
        NSLayoutConstraint.activate([
            funnyCell.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            funnyCell.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            funnyCell.topAnchor.constraint(equalTo: formalCell.bottomAnchor, constant: 28.scale),
            funnyCell.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -28.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 58.scale),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -8.scale : -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CLMakerToneOfVoiceView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets()
        view.setContentOffset(CGPoint.zero, animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.bold(size: 30.scale))
            .lineHeight(34.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "CLMaker.ToneOfVoice.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Inter.regular(size: 17.scale))
            .lineHeight(20.29.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "CLMaker.ToneOfVoice.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeCell(entity: CVMTOVCell.Entity) -> CVMTOVCell {
        let view = CVMTOVCell(entity: entity)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semibold(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = Appearance.custom_ed6f00
        view.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
