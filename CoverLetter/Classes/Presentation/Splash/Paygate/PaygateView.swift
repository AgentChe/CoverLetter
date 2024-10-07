//
//  PaygateView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import UIKit

final class PaygateView: UIView {
    lazy var imageView = makeImageView()
    lazy var closeButton = makeCloseButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(text: "Paygate.Cell1".localized)
    lazy var cell2 = makeCell(text: "Paygate.Cell2".localized)
    lazy var cell3 = makeCell(text: "Paygate.Cell3".localized)
    lazy var leftOptionButton = makeProductButton()
    lazy var rightOptionButton = makeProductButton()
    lazy var continueButton = makeContinueButton()
    lazy var infoLabel = makeInfoLabel()
    lazy var separator = makeSeparator()
    lazy var termsOfServiceButton = makeTermsOfServiceButton()
    lazy var privacyPolicyButton = makePrivacyPolicyButton()
    lazy var restoreButton = makeRestoreButton()
    lazy var preloader = makePreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension PaygateView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
    
    @objc
    func productTapped(sender: UIButton) {
        guard let productButton = sender as? PaygateProductButton else {
            return
        }
        
        [leftOptionButton, rightOptionButton].forEach { $0.marked = false }
        
        productButton.marked = true
    }
}

// MARK: Make constraints
private extension PaygateView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 230.scale : 152.scale),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: ScreenSize.isIphoneXFamily ? 0 : 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13.scale),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: ScreenSize.isIphoneXFamily ? 15.scale : 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 10.scale : 0)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 9.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: 9.scale)
        ])
        
        NSLayoutConstraint.activate([
            leftOptionButton.widthAnchor.constraint(equalToConstant: 174.scale),
            leftOptionButton.heightAnchor.constraint(equalToConstant: 185.scale),
            leftOptionButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -6.scale),
            leftOptionButton.topAnchor.constraint(equalTo: cell3.bottomAnchor, constant: 26.scale)
        ])
        
        NSLayoutConstraint.activate([
            rightOptionButton.widthAnchor.constraint(equalToConstant: 174.scale),
            rightOptionButton.heightAnchor.constraint(equalToConstant: 185.scale),
            rightOptionButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 6.scale),
            rightOptionButton.topAnchor.constraint(equalTo: cell3.bottomAnchor, constant: 26.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 53.scale),
            continueButton.topAnchor.constraint(equalTo: rightOptionButton.bottomAnchor, constant: 21.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 16.scale : 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsOfServiceButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 27.scale),
            termsOfServiceButton.heightAnchor.constraint(equalToConstant: 14.scale),
            termsOfServiceButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 43.scale : 25.scale)
        ])
        
        NSLayoutConstraint.activate([
            privacyPolicyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 141.scale),
            privacyPolicyButton.heightAnchor.constraint(equalToConstant: 14.scale),
            privacyPolicyButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 43.scale : 25.scale)
        ])
        
        NSLayoutConstraint.activate([
            restoreButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 249.scale),
            restoreButton.heightAnchor.constraint(equalToConstant: 14.scale),
            restoreButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 43.scale : 25.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: continueButton.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: ScreenSize.isIphoneXFamily ? "Paygate.Image.X" : "Paygate.Image.8")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Paygate.Close"), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Bitter.bold(size: 30.scale))
            .lineHeight(34.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Paygate.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(text: String) -> PaygateInfoCell {
        let view = PaygateInfoCell()
        view.setup(text: text)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProductButton() -> PaygateProductButton {
        let view = PaygateProductButton()
        view.backgroundColor = Appearance.mono100
        view.layer.borderWidth = 2.scale
        view.layer.cornerRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(productTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Nunito.semiBold(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.main200
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInfoLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.custom_40_50_68.withAlphaComponent(0.6))
            .font(Fonts.SFPro.regular(size: 12.scale))
            .lineHeight(14.4.scale)
        
        let view = UILabel()
        view.attributedText = "Paygate.Info".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.isHidden = !ScreenSize.isIphoneXFamily
        view.backgroundColor = Appearance.main200.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTermsOfServiceButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.custom_40_50_68)
            .font(Fonts.SFPro.semiBold(size: 12.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("Paygate.TermsOfUse".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePrivacyPolicyButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.custom_40_50_68)
            .font(Fonts.SFPro.semiBold(size: 12.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("Paygate.PrivacyPolicy".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRestoreButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.custom_40_50_68)
            .font(Fonts.SFPro.semiBold(size: 12.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("Paygate.RestorePurchases".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.color = Appearance.main200
        view.style = .large
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
