//
//  CLMakerProgressView.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 08.10.2024.
//

import UIKit

final class CLMakerProgressView: UIView {
    lazy var backButton = makeBackButton()
    lazy var templatesDivider = makeDivider()
    lazy var personalInfoDivider = makeDivider()
    lazy var companyInfoDivider = makeDivider()
    lazy var hiringManagerDivider = makeDivider()
    lazy var vacancyDivider = makeDivider()
    lazy var toneOnVoiceDivider = makeDivider()
    lazy var textBlocksDivider = makeDivider()
    
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
extension CLMakerProgressView {
    enum Position: Int {
        case templates
        case personalInfo
        case companyInfo
        case hiringManager
        case vacancy
        case toneOnVoice
        case textBlocks
    }
    
    func move(to position: Position?) {
        isHidden = position == nil
        
        guard let position else { return }
        
        templatesDivider.alpha = position.equalOrGreater(than: .templates) ? 1 : 0.2
        personalInfoDivider.alpha = position.equalOrGreater(than: .personalInfo) ? 1 : 0.2
        companyInfoDivider.alpha = position.equalOrGreater(than: .companyInfo) ? 1 : 0.2
        hiringManagerDivider.alpha = position.equalOrGreater(than: .hiringManager) ? 1 : 0.2
        vacancyDivider.alpha = position.equalOrGreater(than: .vacancy) ? 1 : 0.2
        toneOnVoiceDivider.alpha = position.equalOrGreater(than: .toneOnVoice) ? 1 : 0.2
        textBlocksDivider.alpha = position.equalOrGreater(than: .textBlocks) ? 1 : 0.2
    }
}

// MARK: Private
private extension CLMakerProgressView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension CLMakerProgressView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24.scale),
            backButton.heightAnchor.constraint(equalToConstant: 24.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            templatesDivider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44.scale),
            templatesDivider.widthAnchor.constraint(equalTo: personalInfoDivider.widthAnchor),
            templatesDivider.heightAnchor.constraint(equalToConstant: 4.scale),
            templatesDivider.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            personalInfoDivider.leadingAnchor.constraint(equalTo: templatesDivider.trailingAnchor, constant: 8.scale),
            personalInfoDivider.widthAnchor.constraint(equalTo: companyInfoDivider.widthAnchor),
            personalInfoDivider.heightAnchor.constraint(equalToConstant: 4.scale),
            personalInfoDivider.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            companyInfoDivider.leadingAnchor.constraint(equalTo: personalInfoDivider.trailingAnchor, constant: 8.scale),
            companyInfoDivider.widthAnchor.constraint(equalTo: hiringManagerDivider.widthAnchor),
            companyInfoDivider.heightAnchor.constraint(equalToConstant: 4.scale),
            companyInfoDivider.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hiringManagerDivider.leadingAnchor.constraint(equalTo: companyInfoDivider.trailingAnchor, constant: 8.scale),
            hiringManagerDivider.widthAnchor.constraint(equalTo: vacancyDivider.widthAnchor),
            hiringManagerDivider.heightAnchor.constraint(equalToConstant: 4.scale),
            hiringManagerDivider.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            vacancyDivider.leadingAnchor.constraint(equalTo: hiringManagerDivider.trailingAnchor, constant: 8.scale),
            vacancyDivider.widthAnchor.constraint(equalTo: toneOnVoiceDivider.widthAnchor),
            vacancyDivider.heightAnchor.constraint(equalToConstant: 4.scale),
            vacancyDivider.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            toneOnVoiceDivider.leadingAnchor.constraint(equalTo: vacancyDivider.trailingAnchor, constant: 8.scale),
            toneOnVoiceDivider.widthAnchor.constraint(equalTo: textBlocksDivider.widthAnchor),
            toneOnVoiceDivider.heightAnchor.constraint(equalToConstant: 4.scale),
            toneOnVoiceDivider.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textBlocksDivider.leadingAnchor.constraint(equalTo: toneOnVoiceDivider.trailingAnchor, constant: 8.scale),
            textBlocksDivider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textBlocksDivider.heightAnchor.constraint(equalToConstant: 4.scale),
            textBlocksDivider.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CLMakerProgressView {
    func makeBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "CLMaker.Back"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDivider() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.custom_ed6f00
        view.layer.cornerRadius = 2.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension CLMakerProgressView.Position {
    func equalOrGreater(than position: CLMakerProgressView.Position) -> Bool {
        rawValue >= position.rawValue
    }
}
